extends CharacterBody2D

var player = null

func _ready():
	player = get_parent().get_node("player")


func _physics_process(delta):
	pass

# shoot in spiral	
func shoot_spiral():
	pass
	
# move	
func move():
	pass

# spawns enemy fighters
func spawn_fighter():
	pass
