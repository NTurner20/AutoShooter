extends Node2D
@export var max_spawn_radius : float = 1000.0
@export var min_spawn_radius: float = 400.0
@export var enemy_scenes: Array[PackedScene] = []
@export var player: Node2D = null
@export var max_enemies: int = 10

@export var wave_rounds: Array[int] = [3,6]

var time_to_next_round: float = 10
var current_round: int = 1
var enemy_types: int = 1
var enemies = []


# spawns an enemy at a random location
func spawn_enemy() -> void:
	var enemy_scene = get_random_enemy_scene()
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemies.append(enemy)
		enemy.position = get_spawn_position(player.position, min_spawn_radius, max_spawn_radius)
		add_child(enemy)
	
# gets a random enemy scene
func get_random_enemy_scene() -> PackedScene:
	if enemy_scenes.size() > 0:
		var es = enemy_scenes.slice(0,enemy_types,1)
		return es[randi() % es.size()]
	return null
	
# increases the number of enemy types
func increase_enemy_types() -> void:
	if enemy_types-1 < wave_rounds.size():
		if current_round > wave_rounds[enemy_types-1]:
			enemy_types+=1


func _on_spawn_timer_timeout():
	if enemies.size() < max_enemies:
		spawn_enemy()

func get_spawn_position(center: Vector2, min_distance: float, max_distance: float) -> Vector2:
	var angle = randf() * 2.0 * PI
	var distance = min_distance + (sqrt(randf()) * (max_distance - min_distance))
	var x = center.x + distance * cos(angle)
	var y = center.y + distance * cos(angle)
	return Vector2(x, y)
