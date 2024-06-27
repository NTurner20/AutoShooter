extends Node2D

@export var enemy_scene = preload("res://Enemy.tscn")
@export var spawn_interval = 2.0  # Time between spawns in seconds
@export var spawn_area_size = Vector2(500, 500)  # Size of the spawn area
@export var max_enemies = 10  # Maximum number of enemies in the scene

var time_since_last_spawn = 0.0

func _ready():
	randomize()

func _process(delta: float) -> void:
	time_since_last_spawn += delta
	if time_since_last_spawn >= spawn_interval:
		if get_tree().get_nodes_in_group("enemies").size() < max_enemies:
			spawn_enemy()
		time_since_last_spawn = 0.0

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	var spawn_position = Vector2(
		randf_range(-spawn_area_size.x / 2, spawn_area_size.x / 2),
		randf_range(-spawn_area_size.y / 2, spawn_area_size.y / 2)
	)
	enemy.position = spawn_position
	add_child(enemy)
