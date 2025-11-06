class_name Substance
extends Resource

@export var id: String
@export var display_name: String
@export var description: String
@export var positive_effect: String
@export var negative_effect: String
@export var max_level: int = 5
@export var generates_enemy: bool = true
@export var enemy_type: String = ""
@export var base_spawn_weight: float = 1.0

var level: int = 0

func level_up() -> void:
    level = clamp(level + 1, 1, max_level)

func get_level_multiplier() -> float:
    return 1.0 + float(level - 1) * 0.25

func get_spawn_weight() -> float:
    if not generates_enemy:
        return 0.0
    return base_spawn_weight * (1.0 + 0.35 * (level - 1))

class SubstanceChoice:
    extends RefCounted

    var substance: Substance
    var level: int

    func _init(substance_ref: Substance) -> void:
        substance = substance_ref
        level = substance.level

    func to_dict() -> Dictionary:
        return {
            "id": substance.id,
            "name": substance.display_name,
            "level": level
        }
