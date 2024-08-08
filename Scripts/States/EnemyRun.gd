extends State
class_name EnemyRun

@export var enemy : CharacterBody2D
@export var move_speed := 40.0

var player : CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	
	if direction.length() < 100:
		enemy.velocity = direction.normalized() * move_speed * -1
	if direction.length() > 300:
		Transitioned.emit(self, "follow")
