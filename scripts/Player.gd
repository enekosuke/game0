class_name Player
extends CharacterBody2D

signal level_up(level: int)
signal health_changed(current: float, max: float)
signal xp_changed(current: float, required: float, level: int)
signal projectiles_changed(count: int)
signal damage_changed(value: float)

@export var move_speed: float = 220.0
@export var max_health: float = 100.0
@export var projectile_scene: PackedScene
@export var attack_interval: float = 1.4

var current_health: float
var xp: float = 0.0
var level: int = 1
var xp_required: float = 100.0
var speed_multiplier: float = 1.0
var damage_multiplier: float = 1.0
var fire_rate_multiplier: float = 1.0
var projectile_frequency_bonus: float = 0.0
var projectile_count: int = 1
var regeneration_per_second: float = 0.0
var health_drain_amount: float = 5.0
var blur_effect_active: bool = false
var random_blur_enabled: bool = false

var attack_timer: Timer
var sugar_penalty_timer: Timer
var health_drain_timer: Timer
var blur_timer: Timer
var blur_event_timer: Timer
var enemy_slow_aura_level: float = 0.0
var enemy_spawner: Node
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
    current_health = max_health
    attack_timer = Timer.new()
    attack_timer.wait_time = attack_interval
    attack_timer.autostart = true
    attack_timer.timeout.connect(_on_attack_timeout)
    add_child(attack_timer)

    sugar_penalty_timer = Timer.new()
    sugar_penalty_timer.timeout.connect(_apply_sugar_penalty)
    add_child(sugar_penalty_timer)

    health_drain_timer = Timer.new()
    health_drain_timer.timeout.connect(_on_health_drain)
    add_child(health_drain_timer)

    blur_timer = Timer.new()
    blur_timer.one_shot = true
    blur_timer.timeout.connect(_on_blur_timer_timeout)
    add_child(blur_timer)

    blur_event_timer = Timer.new()
    blur_event_timer.one_shot = true
    blur_event_timer.timeout.connect(_on_blur_event_timeout)
    add_child(blur_event_timer)

    emit_signal("health_changed", current_health, max_health)
    emit_signal("xp_changed", xp, xp_required, level)
    emit_signal("projectiles_changed", projectile_count)
    emit_signal("damage_changed", get_damage())

func _physics_process(delta: float) -> void:
    var input_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = input_vector * move_speed * speed_multiplier
    move_and_slide()
    _apply_regeneration(delta)

func _process(delta: float) -> void:
    if GameState.run_active:
        GameState.add_time(delta)

func set_enemy_spawner(spawner: Node) -> void:
    enemy_spawner = spawner

func _on_attack_timeout() -> void:
    var enemies := get_tree().get_nodes_in_group("enemies")
    if enemies.is_empty():
        return
    var target := _find_closest_enemy(enemies)
    if target == null:
        return
    var direction := (target.global_position - global_position).normalized()
    var count := projectile_count
    for i in range(count):
        var projectile: Node2D = projectile_scene.instantiate()
        projectile.global_position = global_position
        var spread := 0.1 * (i - (count - 1) / 2.0)
        projectile.set_direction(direction.rotated(spread))
        projectile.damage = get_damage()
        get_tree().current_scene.add_child(projectile)
    var new_wait := max(0.2, attack_interval / (fire_rate_multiplier + projectile_frequency_bonus))
    attack_timer.wait_time = new_wait
    attack_timer.start()

func _find_closest_enemy(enemies: Array) -> Node2D:
    var closest: Node2D
    var min_distance := INF
    for enemy in enemies:
        if not is_instance_valid(enemy):
            continue
        var distance := global_position.distance_squared_to(enemy.global_position)
        if distance < min_distance:
            min_distance = distance
            closest = enemy
    return closest

func take_damage(amount: float, knockback: Vector2=Vector2.ZERO) -> void:
    current_health = max(0.0, current_health - amount)
    emit_signal("health_changed", current_health, max_health)
    if knockback != Vector2.ZERO:
        velocity += knockback
    if current_health <= 0.0:
        _on_death()

func heal(amount: float) -> void:
    current_health = clamp(current_health + amount, 0.0, max_health)
    emit_signal("health_changed", current_health, max_health)

func gain_xp(amount: float) -> void:
    xp += amount
    while xp >= xp_required:
        xp -= xp_required
        level += 1
        xp_required *= 1.25
        level_up.emit(level)
    emit_signal("xp_changed", xp, xp_required, level)

func _on_death() -> void:
    GameState.finish_run()
    get_tree().change_scene_to_file("res://ui/DeathScreen.tscn")

func _apply_regeneration(delta: float) -> void:
    if regeneration_per_second > 0.0 and current_health > 0.0:
        current_health = clamp(current_health + regeneration_per_second * delta, 0, max_health)
        emit_signal("health_changed", current_health, max_health)

func add_speed_bonus(multiplier: float) -> void:
    speed_multiplier += multiplier

func add_damage_bonus(multiplier: float) -> void:
    damage_multiplier += multiplier
    emit_signal("damage_changed", get_damage())

func add_fire_rate_bonus(multiplier: float) -> void:
    fire_rate_multiplier += multiplier

func add_projectile_bonus(amount: int) -> void:
    projectile_count += amount
    emit_signal("projectiles_changed", projectile_count)

func add_projectile_frequency_bonus(multiplier: float) -> void:
    projectile_frequency_bonus += multiplier

func add_regeneration_bonus(percent_per_minute: float) -> void:
    regeneration_per_second += (max_health * percent_per_minute) / 60.0

func add_fire_rate_penalty(multiplier: float) -> void:
    fire_rate_multiplier = max(0.5, fire_rate_multiplier - multiplier)

func schedule_sugar_penalty() -> void:
    sugar_penalty_timer.wait_time = 20.0
    sugar_penalty_timer.start()

func _apply_sugar_penalty() -> void:
    speed_multiplier = max(0.6, speed_multiplier - 0.05)
    sugar_penalty_timer.start()

func enable_tremors(level: int) -> void:
    # Implementation placeholder for camera shake or sprite jitter
    pass

func apply_screen_blur(duration: float) -> void:
    if sprite:
        sprite.modulate = Color(1, 1, 1, 0.6)
    blur_effect_active = true
    if blur_event_timer:
        blur_event_timer.stop()
    blur_timer.wait_time = duration
    blur_timer.start()

func enable_random_blur() -> void:
    random_blur_enabled = true
    if blur_effect_active or not blur_event_timer.is_stopped():
        return
    _schedule_next_blur_event()

func schedule_health_drain(amount: float, interval: float) -> void:
    health_drain_amount = amount
    health_drain_timer.wait_time = interval
    health_drain_timer.start()

func _on_health_drain() -> void:
    take_damage(health_drain_amount)
    health_drain_timer.start()

func enable_enemy_slow_aura(level_multiplier: float) -> void:
    enemy_slow_aura_level = level_multiplier

func modify_enemy_frequency(enemy_type: String, value: float) -> void:
    if enemy_spawner:
        enemy_spawner.modify_spawn_weight(enemy_type, value)

func get_damage() -> float:
    return 10.0 * damage_multiplier

func grant_experience_orb(amount: float) -> void:
    gain_xp(amount)

func _on_blur_timer_timeout() -> void:
    blur_effect_active = false
    if sprite:
        sprite.modulate = Color(1, 1, 1, 1)
    if random_blur_enabled:
        _schedule_next_blur_event()

func _on_blur_event_timeout() -> void:
    apply_screen_blur(randf_range(1.5, 3.5))

func _schedule_next_blur_event() -> void:
    blur_event_timer.wait_time = randf_range(6.0, 12.0)
    blur_event_timer.start()
