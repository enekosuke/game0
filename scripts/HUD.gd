class_name HUD
extends Control

@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/Health/HealthBar
@onready var health_label: Label = $MarginContainer/VBoxContainer/Health/HealthLabel
@onready var xp_bar: ProgressBar = $MarginContainer/VBoxContainer/XP/XPBar
@onready var level_label: Label = $MarginContainer/VBoxContainer/XP/LevelLabel
@onready var damage_label: Label = $MarginContainer/VBoxContainer/Stats/DamageValue
@onready var projectiles_label: Label = $MarginContainer/VBoxContainer/Stats/ProjectileValue

func update_health(current: float, maximum: float) -> void:
    health_bar.max_value = maximum
    health_bar.value = current
    health_label.text = "Vida: %d / %d" % [int(current), int(maximum)]

func update_xp(current: float, required: float, level: int) -> void:
    xp_bar.max_value = required
    xp_bar.value = current
    level_label.text = "Nivel: %d" % level

func update_damage(value: float) -> void:
    damage_label.text = "Daño: %.1f" % value

func update_projectiles(count: int) -> void:
    projectiles_label.text = "Proyectiles: %d" % count
