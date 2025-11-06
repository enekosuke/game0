extends Node

const SubstanceChoice = preload("res://scripts/SubstanceDefinitions.gd").SubstanceChoice

const SAVE_PATH := "user://autosurvival_stats.save"

var best_time: float = 0.0
var best_kills: int = 0
var current_run_time: float = 0.0
var current_kills: int = 0
var substances_taken: Array[SubstanceChoice] = []
var run_active: bool = false

func start_run() -> void:
    run_active = true
    current_run_time = 0.0
    current_kills = 0
    substances_taken.clear()

func finish_run() -> void:
    run_active = false
    if current_run_time > best_time:
        best_time = current_run_time
    if current_kills > best_kills:
        best_kills = current_kills
    save_stats()

func add_kill() -> void:
    current_kills += 1

func add_time(delta: float) -> void:
    if run_active:
        current_run_time += delta

func register_substance(choice: SubstanceChoice) -> void:
    for existing: SubstanceChoice in substances_taken:
        if existing.substance.id == choice.substance.id:
            existing.level = choice.level
            return
    substances_taken.append(choice)

func get_best_time_string() -> String:
    var minutes := int(best_time) / 60
    var seconds := int(best_time) % 60
    return "%02d:%02d" % [minutes, seconds]

func get_best_time_string_from(time_value: float) -> String:
    var minutes := int(time_value) / 60
    var seconds := int(time_value) % 60
    return "%02d:%02d" % [minutes, seconds]

func save_stats() -> void:
    var data := {
        "best_time": best_time,
        "best_kills": best_kills
    }
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file:
        file.store_var(data)
        file.close()

func load_stats() -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        return
    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file:
        var data_variant: Variant = file.get_var()
        if data_variant is Dictionary:
            var data: Dictionary = data_variant
            best_time = float(data.get("best_time", 0.0))
            best_kills = int(data.get("best_kills", 0))
        file.close()
