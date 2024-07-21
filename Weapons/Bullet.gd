extends Area2D

@export var speed = 500
var direction = Vector2()
var damage = 1
var player = null
var penetration = null
var last_body_enetered = null
func _ready():
	player = get_tree().get_root().get_node("World/Player")
	#penetration = player.get_child(2).penetration

func _process(delta: float) -> void:
	position += direction * speed * delta
	if player:
		if (player.position - position).length() > 2000:  # Adjust as needed
			queue_free()
func initialize(direction: Vector2, penetration) -> void:
	self.direction = direction
	self.penetration = penetration

func _on_Bullet_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		if body != last_body_enetered:
			last_body_enetered = body
			body.take_hit(damage)
			print(penetration)
			if penetration > 1:
				penetration -= 1
			elif penetration == 1:
				queue_free()


func _on_body_exited(body):
	last_body_enetered = null
