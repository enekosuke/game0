class_name SubstanceSelection
extends Control

signal closed

@onready var options_container: VBoxContainer = $Panel/MarginContainer/VBoxContainer/Options
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/Title
@onready var description_label: Label = $Panel/MarginContainer/VBoxContainer/Description

var manager: Node
var player: Player
var current_options: Array = []

func present(manager_ref: Node, player_ref: Player, options: Array) -> void:
    manager = manager_ref
    player = player_ref
    current_options = options
    visible = true
    _refresh()
    get_tree().paused = true

func _refresh() -> void:
    for child in options_container.get_children():
        child.queue_free()
    for substance in current_options:
        var button := Button.new()
        var display_level := min(substance.level + 1, substance.max_level)
        button.text = "%s (Nivel %d)" % [substance.display_name, display_level]
        button.tooltip_text = "%s\nNegativo: %s" % [substance.positive_effect, substance.negative_effect]
        button.pressed.connect(func():
            _select_substance(substance)
        )
        options_container.add_child(button)
    if current_options.size() > 0:
        title_label.text = "Elige una sustancia"
        description_label.text = "Cada elección potencia al jugador pero altera la oleada enemiga."

func _select_substance(substance: Substance) -> void:
    manager.apply_substance(substance, player)
    hide_panel()

func hide_panel() -> void:
    visible = false
    get_tree().paused = false
    closed.emit()
