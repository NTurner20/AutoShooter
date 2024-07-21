extends Node2D

@export var speed = 100
@export var bullet_scene = preload("res://Weapons/bullet.tscn")
@export var gun_range = 600
@export var shot_cooldown: float = 2.0
@export var damage = 1
@export var penetration = 1
var time_since_last_shot = 0
@export var child_weapon : Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#child_weapon = get_child(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if child_weapon:
		time_since_last_shot += delta
		if time_since_last_shot > shot_cooldown:
			child_weapon.shoot()
			time_since_last_shot = 0
		

func find_nearest_enemy() -> Node2D:
	var nearest_enemy = null
	var shortest_distance = INF
	for enemy in get_parent().get_parent().get_children():
		if enemy.is_in_group("enemies"):
			var distance = global_position.distance_to(enemy.global_position)
			if distance < shortest_distance:
				shortest_distance = distance
				if shortest_distance > gun_range:
					nearest_enemy = null
				else:
					nearest_enemy = enemy
	return nearest_enemy	
	
func find_healthiest_enemy() -> Node2D:
	var healthiest_enemy = null
	for enemy in get_tree().get_children():
		if enemy.is_in_group("enemies"):
			var distance = position.distance_to(enemy.position)
			if distance > gun_range:
				healthiest_enemy = healthiest_enemy
			var health = enemy.health
			if health > healthiest_enemy.health:
				healthiest_enemy = enemy
	return healthiest_enemy
