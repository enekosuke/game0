class_name Enemy
extends CharacterBody2D

const XpOrb = preload("res://scripts/XpOrb.gd")

@export var enemy_type: String = "default"
@export var max_health: float = 30.0
@export var move_speed: float = 120.0
@export var contact_damage: float = 10.0
@export var knockback_force: float = 250.0
@export var xp_reward: float = 25.0
@export var xp_orb_scene: PackedScene

var current_health: float
var target: Player
var health_multiplier: float = 1.0

func _ready() -> void:
    add_to_group("enemies")
    current_health = max_health * health_multiplier

func set_target(player: Player) -> void:
    target = player

func set_health_multiplier(value: float) -> void:
    health_multiplier = value
    current_health = max_health * health_multiplier

func _physics_process(delta: float) -> void:
    if not is_instance_valid(target):
        return
    var direction := (target.global_position - global_position)
    var dist := direction.length()
    if dist == 0:
        return
    direction = direction / dist
    var effective_speed := move_speed
    if target.enemy_slow_aura_level > 0 and dist < 180:
        effective_speed *= max(0.4, 1.0 - 0.2 * target.enemy_slow_aura_level)
    velocity = direction * effective_speed
    var collision := move_and_collide(velocity * delta)
    if collision and collision.get_collider() == target:
        _damage_player(direction)

func _damage_player(direction: Vector2) -> void:
    if not is_instance_valid(target):
        return
    target.take_damage(contact_damage, -direction * knockback_force)

func take_projectile_damage(amount: float) -> void:
    current_health -= amount
    if current_health <= 0:
        die()

func die() -> void:
    GameState.add_kill()
    if xp_orb_scene:
        var orb: Area2D = xp_orb_scene.instantiate()
        orb.global_position = global_position
        if orb is XpOrb and is_instance_valid(target):
            orb.xp_amount = xp_reward
            orb.set_target(target)
        get_tree().current_scene.add_child(orb)
    queue_free()
