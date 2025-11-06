class_name SubstanceLibrary
extends Node

const Substance = preload("res://scripts/SubstanceDefinitions.gd").Substance

var substances: Dictionary = {}

func _ready() -> void:
    _register_substances()

func _register_substances() -> void:
    substances.clear()
    _add_substance("tabaco", "Tabaco", "+10% velocidad de movimiento", "+5% frecuencia de enemigos de humo", "humo", generates_enemy=true, base_spawn_weight=1.0)
    _add_substance("alcohol", "Alcohol", "+15% daño por proyectil", "Pantalla borrosa ocasional", "borracho", generates_enemy=true, base_spawn_weight=1.2)
    _add_substance("azucar", "Azúcar", "+20% cadencia de disparo", "-5% velocidad cada 20s", "dulce", generates_enemy=true, base_spawn_weight=1.1)
    _add_substance("paracetamol", "Paracetamol", "+1 proyectil por disparo", "Sin efectos negativos", "", generates_enemy=false)
    _add_substance("cafeina", "Cafeína", "+5% velocidad y +10% proyectiles/min", "Temblores incrementados", "taza", generates_enemy=true, base_spawn_weight=1.3)
    _add_substance("heroina", "Heroína", "+30% daño y ralentiza enemigos cercanos", "Pierde 5 de vida cada 30s", "sombra", generates_enemy=true, base_spawn_weight=0.8)
    _add_substance("marihuana", "Marihuana", "+20% curación pasiva por minuto", "-10% cadencia de disparo", "nube", generates_enemy=true, base_spawn_weight=0.9)

func _add_substance(id: String, name: String, positive: String, negative: String, enemy: String, generates_enemy: bool=true, base_spawn_weight: float=1.0) -> void:
    var s := Substance.new()
    s.id = id
    s.display_name = name
    s.description = "%s / %s" % [positive, negative]
    s.positive_effect = positive
    s.negative_effect = negative
    s.generates_enemy = generates_enemy
    s.enemy_type = enemy
    s.base_spawn_weight = base_spawn_weight
    substances[id] = s

func get_all() -> Array[Substance]:
    return substances.values()

func get_by_id(id: String) -> Substance:
    return substances.get(id)
