extends Control

var player: Node = null
# Called when the node enters the scene tree for the first time.
func _ready():
	size = Vector2(200,50)
	player = get_tree().get_root().get_node("World/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player:
		$Label.text = "XP: " + str(player.xp)
