extends Area2D
@export var speed = 350
var direction = Vector2()
var time_alive = 0.0
@export var damage = 5
@export var lifetime = 1000
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initialize(direction: Vector2) -> void:
	self.direction = direction
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()


func _on_body_entered(body):
	if body.name == 'Player':
		body.take_hit(self)
