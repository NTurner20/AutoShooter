extends Node2D

@export var spread: int = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shoot() -> void:
	var nearest_enemy = get_parent().find_nearest_enemy()
	print('in shoot')
	if nearest_enemy:
		print('shoot!')
		if spread > 1:
			for i in range(spread):
				var bullet = get_parent().bullet_scene.instantiate()
				bullet.damage = get_parent().damage
				bullet.position = global_position
				var base_direction  = (nearest_enemy.global_position - global_position).normalized()
				# Calculate angle offset
				var angle_offset = (i - (spread - 1) / 2.0) * 0.2  # Adjust the spread angle factor as needed
			
				# Rotate the base direction by the angle offset
				var rotated_direction = base_direction.rotated(angle_offset)

				bullet.initialize(rotated_direction,get_parent().penetration)
				get_tree().get_root().add_child(bullet)
		else:
			print('no spread')
			var bullet = get_parent().bullet_scene.instantiate()
			bullet.damage = get_parent().damage
			bullet.position = global_position

			var direction = (nearest_enemy.global_position - global_position).normalized()
			bullet.initialize(direction,get_parent().penetration)
			get_tree().get_root().add_child(bullet)
