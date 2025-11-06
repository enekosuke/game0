class_name XpOrb
extends Area2D

@export var xp_amount: float = 20.0
var target: Player

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func set_target(player: Player) -> void:
    target = player

func _on_body_entered(body: Node) -> void:
    if body == target:
        target.gain_xp(xp_amount)
        queue_free()
