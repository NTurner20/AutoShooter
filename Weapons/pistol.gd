extends Node2D

@export var spread: int = 1
@export var gun : Node2D
# Called when the node enters the scene tree for the first time.

func shoot() -> void:
	var nearest_enemy = gun.find_nearest_enemy()
	#print('in shoot')
	if nearest_enemy:
		#print('no spread')
		var bullet = get_parent().bullet_scene.instantiate()
		bullet.damage = get_parent().damage
		bullet.position = global_position

		var direction = (nearest_enemy.global_position - global_position).normalized()
		bullet.initialize(direction,gun.penetration)
		$"../AudioStreamPlayer".play()
		get_tree().get_root().add_child(bullet)
