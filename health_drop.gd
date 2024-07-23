extends Area2D

@export var health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite2D.self_modulate.a *= 0.99


func _on_timer_timeout():
	queue_free()


func _on_color_timer_timeout():
	$Sprite2D.self_modulate.a -= 1/$Timer.wait_time
	$ColorTimer.start()
