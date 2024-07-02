extends Node2D

@export var target_position: Vector2

var t = 0.0

func _physics_process(delta):
	t += delta * 0.4
	
	position = position.lerp(target_position,t)




