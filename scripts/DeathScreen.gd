extends Control

@onready var time_label: Label = $MarginContainer/VBoxContainer/TimeLabel
@onready var kills_label: Label = $MarginContainer/VBoxContainer/KillsLabel
@onready var substances_container: VBoxContainer = $MarginContainer/VBoxContainer/Substances
@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton
@onready var retry_button: Button = $MarginContainer/VBoxContainer/RetryButton

func _ready() -> void:
    time_label.text = "Tiempo sobrevivido: %s" % GameState.get_best_time_string_from(GameState.current_run_time)
    kills_label.text = "Enemigos derrotados: %d" % GameState.current_kills
    for choice in GameState.substances_taken:
        var label := Label.new()
        var data := choice.to_dict()
        var name := data.get("name", "?")
        var level := data.get("level", 1)
        label.text = "%s - Nivel %d" % [name, level]
        substances_container.add_child(label)
    if GameState.substances_taken.is_empty():
        var label := Label.new()
        label.text = "Sin sustancias seleccionadas"
        substances_container.add_child(label)
    back_button.pressed.connect(_on_back_pressed)
    retry_button.pressed.connect(_on_retry_pressed)

func _on_back_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_retry_pressed() -> void:
    GameState.start_run()
    get_tree().change_scene_to_file("res://scenes/Game.tscn")
