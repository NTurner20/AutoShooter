extends CharacterBody2D

@export var speed = 100
var player = null

func _ready() -> void:
	player = get_parent().get_node("Player")

func _process(delta: float) -> void:
	if player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed * delta * 100
		move_and_slide()
