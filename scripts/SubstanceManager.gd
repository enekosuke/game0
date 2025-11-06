class_name SubstanceManager
extends Node

const SubstanceDefinitions = preload("res://scripts/SubstanceDefinitions.gd")
const Substance = SubstanceDefinitions.Substance
const SubstanceChoice = SubstanceDefinitions.SubstanceChoice

signal options_ready(options: Array)
signal substance_selected(substance: Substance)

@export var library_path := "res://scripts/SubstanceLibrary.gd"

var library: Node
var rng := RandomNumberGenerator.new()

func _ready() -> void:
    library = load(library_path).new()
    add_child(library)
    rng.randomize()

func roll_options(count: int = 4) -> Array:
    var list: Array = []
    for substance in library.get_all():
        if substance.level < substance.max_level:
            list.append(substance)
    if list.is_empty():
        list = library.get_all().duplicate()
    else:
        list = list.duplicate()
    list.shuffle()
    var options: Array = list.slice(0, min(count, list.size()))
    options_ready.emit(options)
    return options

func apply_substance(substance: Substance, player: Node) -> void:
    substance.level_up()
    _apply_positive_effect(substance, player)
    _apply_negative_effect(substance, player)
    GameState.register_substance(SubstanceChoice.new(substance))
    substance_selected.emit(substance)

func _apply_positive_effect(substance: Substance, player: Node) -> void:
    var level_multiplier: float = substance.get_level_multiplier()
    match substance.id:
        "tabaco":
            player.add_speed_bonus(0.10 * level_multiplier)
        "alcohol":
            player.add_damage_bonus(0.15 * level_multiplier)
            player.apply_screen_blur(3.0)
        "azucar":
            player.add_fire_rate_bonus(0.20 * level_multiplier)
        "paracetamol":
            player.add_projectile_bonus(1)
        "cafeina":
            player.add_speed_bonus(0.05 * level_multiplier)
            player.add_projectile_frequency_bonus(0.10 * level_multiplier)
        "heroina":
            player.add_damage_bonus(0.30 * level_multiplier)
            player.enable_enemy_slow_aura(level_multiplier)
        "marihuana":
            player.add_regeneration_bonus(0.20 * level_multiplier)
        _:
            pass

func _apply_negative_effect(substance: Substance, player: Node) -> void:
    match substance.id:
        "tabaco":
            player.modify_enemy_frequency("humo", 0.05 * substance.level)
        "alcohol":
            player.enable_random_blur()
            player.modify_enemy_frequency("borracho", 0.08 * substance.level)
        "azucar":
            player.schedule_sugar_penalty()
            player.modify_enemy_frequency("dulce", 0.07 * substance.level)
        "cafeina":
            player.enable_tremors(substance.level)
            player.modify_enemy_frequency("taza", 0.09 * substance.level)
        "heroina":
            player.schedule_health_drain(5.0 * substance.level, max(6.0, 30.0 / substance.level))
            player.modify_enemy_frequency("sombra", 0.06 * substance.level)
        "marihuana":
            player.add_fire_rate_penalty(0.10 * substance.level)
            player.modify_enemy_frequency("nube", 0.05 * substance.level)
        _:
            if substance.generates_enemy:
                player.modify_enemy_frequency(substance.enemy_type, 0.05 * substance.level)
