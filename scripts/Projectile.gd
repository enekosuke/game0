extends Area2D

@export var speed: float = 480.0
var direction: Vector2 = Vector2.RIGHT
var damage: float = 10.0
var lifetime: float = 3.0

func _ready() -> void:
    $CollisionShape2D.disabled = false
    body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
    position += direction * speed * delta
    lifetime -= delta
    if lifetime <= 0:
        queue_free()

func set_direction(dir: Vector2) -> void:
    direction = dir.normalized()

func _on_body_entered(body: Node) -> void:
    if body.has_method("take_projectile_damage"):
        body.take_projectile_damage(damage)
    queue_free()
