extends Node2D

class_name EnemySpawner

@export var spawn_interval: float = 2.5
@export var spawn_radius: float = 500.0

var player: Player
var spawn_timer: Timer
var rng := RandomNumberGenerator.new()
var enemy_catalog := {
    "humo": preload("res://scenes/enemies/HumoEnemy.tscn"),
    "borracho": preload("res://scenes/enemies/BorrachoEnemy.tscn"),
    "dulce": preload("res://scenes/enemies/DulceEnemy.tscn"),
    "taza": preload("res://scenes/enemies/TazaEnemy.tscn"),
    "sombra": preload("res://scenes/enemies/SombraEnemy.tscn"),
    "nube": preload("res://scenes/enemies/NubeEnemy.tscn")
}
var spawn_weights := {
    "humo": 1.0,
    "borracho": 0.4,
    "dulce": 0.5,
    "taza": 0.3,
    "sombra": 0.2,
    "nube": 0.3
}
var level_health_scale: float = 1.0

func _ready() -> void:
    rng.randomize()
    spawn_timer = Timer.new()
    spawn_timer.wait_time = spawn_interval
    spawn_timer.autostart = true
    spawn_timer.timeout.connect(_spawn_enemy)
    add_child(spawn_timer)

func set_player(player_ref: Player) -> void:
    player = player_ref

func modify_spawn_weight(enemy_type: String, amount: float) -> void:
    enemy_type = _normalize_enemy_type(enemy_type)
    if not spawn_weights.has(enemy_type):
        spawn_weights[enemy_type] = max(0.1, amount)
    else:
        spawn_weights[enemy_type] = max(0.1, spawn_weights[enemy_type] + amount)

func on_player_level_up(level: int) -> void:
    level_health_scale += 0.12
    spawn_interval = max(0.7, spawn_interval * 0.97)
    spawn_timer.wait_time = spawn_interval

func _spawn_enemy() -> void:
    if not player:
        return
    var enemy_type := _normalize_enemy_type(_pick_enemy_type())
    var scene: PackedScene = enemy_catalog.get(enemy_type)
    if scene == null:
        if enemy_type == "humo":
            scene = load("res://scenes/enemies/HumonEnemy.tscn") as PackedScene
    if scene == null:
        return
    var enemy: Enemy = scene.instantiate()
    enemy.set_target(player)
    enemy.set_health_multiplier(level_health_scale)
    var spawn_position := _random_position_around_player()
    enemy.global_position = spawn_position
    get_tree().current_scene.add_child(enemy)
    spawn_timer.wait_time = spawn_interval

func _pick_enemy_type() -> String:
    var total := 0.0
    for value in spawn_weights.values():
        total += value
    var roll := rng.randf() * max(total, 0.1)
    for type in spawn_weights.keys():
        roll -= spawn_weights[type]
        if roll <= 0:
            return type
    return spawn_weights.keys()[0]

func _random_position_around_player() -> Vector2:
    var angle := rng.randf() * TAU
    var radius := spawn_radius + rng.randf() * 100.0
    var offset := Vector2(cos(angle), sin(angle)) * radius
    return player.global_position + offset

func _normalize_enemy_type(enemy_type: String) -> String:
    if enemy_type == "humon":
        return "humo"
    return enemy_type
