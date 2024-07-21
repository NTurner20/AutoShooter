extends Node2D

@export var enemy_scene = preload("res://Enemies/enemy.tscn")
@export var enemy2_scene = preload("res://Enemies/enemy2.tscn")
@export var enemy3_scene = preload("res://Enemies/enemy3.tscn")
@export var enemy_shooter_scene = preload("res://Enemies/enemy_shooter.tscn")
@export var spawn_interval = 3.0  # Time between spawns in seconds
@export var player_scene = preload("res://player.tscn")
@export var spawn_area_size = Vector2(51200, 51200)  # Size of the spawn area
@export var max_enemies = 10  # Maximum number of enemies in the scene
@export var spawn_radius = 300
@export var max_spawn_radius = 1500



var time_since_last_spawn = 0.0
var next_round = 20
var time_since_round_start = 0
@export var round = 12
var paused = false


func _ready():
	randomize()
	get_tree().paused = false

func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("pause"):
		#if get_tree().paused == false:
			#print('pausing...2')
			#pause()
	$UI/PlayerHealth.max_value = $Player.max_health
	$UI/PlayerHealth.value = $Player.health
	time_since_last_spawn += delta
	time_since_round_start += delta
	if time_since_last_spawn >= spawn_interval:
		if get_tree().get_nodes_in_group("enemies").size() < max_enemies:
			spawn_enemy()
		time_since_last_spawn = 0.0
		
	if time_since_round_start > next_round:
		start_next_round()

func spawn_enemy() -> void:
	var enemy = null
	if round < 5:
		enemy = enemy_scene.instantiate()

	elif round < 9:
		var enemy_index = randi_range(0,1)

		if enemy_index == 0:
			enemy = enemy_scene.instantiate()
		else:
			enemy = enemy2_scene.instantiate()
	elif round < 12:
		var enemy_index = randi_range(0,2)

		if enemy_index == 0:
			enemy = enemy_scene.instantiate()
		else:
			enemy = enemy2_scene.instantiate()
	else:
		var enemy_index = randi_range(0,3)
		enemy = null
		if enemy_index == 0:
			enemy = enemy_scene.instantiate()
		elif enemy_index == 1 :
			enemy = enemy2_scene.instantiate()
		elif enemy_index == 2:
			enemy = enemy_shooter_scene.instantiate()
		else:
			enemy = enemy3_scene.instantiate()
	var spawn_position = get_enemy_spawn_position()
	print(spawn_position)
	enemy.global_position = spawn_position
	add_child(enemy)
#func pause() -> void:
	#get_tree().paused = true
	#$UI/CharacterInfo.visible = true
	#paused = true

func start_next_round() -> void:
	round += 1
	max_enemies += 1
	spawn_interval = spawn_interval * 0.9
	#print(round)
	next_round = next_round * 1.3
	
func get_enemy_spawn_position() -> Vector2:
	var spawn_position = Vector2(
				randf_range(-spawn_area_size.x/2,  spawn_area_size.x/2),
				randf_range(-spawn_area_size.y/2, spawn_area_size.y/2)
			) 
	while ((spawn_position - $Player.global_position).length() < spawn_radius or (spawn_position - $Player.global_position).length() >= max_spawn_radius or spawn_position.x <=0 or spawn_position.y <= 0 or spawn_position.x >= spawn_area_size.x*512 or spawn_position.y >= spawn_area_size.y*512):
		spawn_position = $Player.global_position + Vector2(
				randf_range(-spawn_area_size.x/2,  spawn_area_size.x/2),
				randf_range(-spawn_area_size.y/2, spawn_area_size.y/2)
			) 
	return spawn_position


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
