extends Area2D

@export var speed = 500
var direction = Vector2()

func _process(delta: float) -> void:
	position += direction * speed * delta
	if position.length() > 2000:  # Adjust as needed
		queue_free()
func initialize(direction: Vector2) -> void:
	self.direction = direction

func _on_Bullet_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		body.take_hit()
		queue_free()
