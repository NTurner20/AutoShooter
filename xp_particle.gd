extends Node2D

@export var target_position: Vector2

var t = 0.0

func _physics_process(delta):
	t += delta * 0.4
	
	position = position.lerp(target_position,t)
	






func _on_timer_timeout():
	queue_free()


func _on_colortimer_timeout():
	$Sprite2D.self_modulate.a -= 1/$Timer.wait_time
	$Colortimer.start()
