extends Node2D

@export var enemy_scene = preload("res://Enemy.tscn")
@export var spawn_interval = 2.0  # Time between spawns in seconds
@export var player_scene = preload("res://player.tscn")
@export var spawn_area_size = Vector2(1000, 1000)  # Size of the spawn area
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
		randf_range(0,  spawn_area_size.x),
		randf_range(0, spawn_area_size.y)
	)
	enemy.position = spawn_position
	add_child(enemy)
