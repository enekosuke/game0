extends Control

@onready var start_button: Button = $VBoxContainer/Buttons/StartButton
@onready var best_time_label: Label = $VBoxContainer/Stats/BestTimeLabel
@onready var best_kills_label: Label = $VBoxContainer/Stats/BestKillsLabel
@onready var config_button: Button = $VBoxContainer/Buttons/ConfigButton
@onready var credits_button: Button = $VBoxContainer/Buttons/CreditsButton

func _ready() -> void:
    GameState.load_stats()
    _update_stats()
    start_button.pressed.connect(_on_start_pressed)
    config_button.pressed.connect(_on_config_pressed)
    credits_button.pressed.connect(_on_credits_pressed)

func _update_stats() -> void:
    best_time_label.text = "Mejor tiempo: %s" % GameState.get_best_time_string()
    best_kills_label.text = "Récord de bajas: %d" % GameState.best_kills

func _on_start_pressed() -> void:
    GameState.start_run()
    get_tree().change_scene_to_file("res://scenes/Game.tscn")

func _on_config_pressed() -> void:
    get_tree().change_scene_to_file("res://ui/SettingsScreen.tscn")

func _on_credits_pressed() -> void:
    get_tree().change_scene_to_file("res://ui/CreditsScreen.tscn")
