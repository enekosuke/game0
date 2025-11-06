extends Node2D

@onready var player: Player = $Player
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var substance_manager: SubstanceManager = $SubstanceManager
@onready var hud: HUD = $CanvasLayer/HUD
@onready var selection: SubstanceSelection = $CanvasLayer/SubstanceSelection

func _ready() -> void:
    GameState.run_active = true
    enemy_spawner.set_player(player)
    player.set_enemy_spawner(enemy_spawner)
    player.level_up.connect(_on_player_level_up)
    player.health_changed.connect(_on_player_health_changed)
    player.xp_changed.connect(_on_player_xp_changed)
    player.projectiles_changed.connect(_on_projectiles_changed)
    player.damage_changed.connect(_on_damage_changed)
    selection.closed.connect(_on_selection_closed)
    substance_manager.substance_selected.connect(_on_substance_selected)
    _on_player_health_changed(player.current_health, player.max_health)
    _on_player_xp_changed(player.xp, player.xp_required, player.level)
    _on_projectiles_changed(player.projectile_count)
    _on_damage_changed(player.get_damage())

func _on_player_level_up(level: int) -> void:
    enemy_spawner.on_player_level_up(level)
    var options: Array = substance_manager.roll_options()
    selection.present(substance_manager, player, options)

func _on_player_health_changed(current: float, maximum: float) -> void:
    hud.update_health(current, maximum)

func _on_player_xp_changed(current: float, required: float, level: int) -> void:
    hud.update_xp(current, required, level)

func _on_projectiles_changed(count: int) -> void:
    hud.update_projectiles(count)

func _on_damage_changed(value: float) -> void:
    hud.update_damage(value)

func _on_selection_closed() -> void:
    # Additional handling can be added here
    pass

func _on_substance_selected(substance: Substance) -> void:
    # Hook for future analytics or feedback
    pass
