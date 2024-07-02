extends CharacterBody2D

@export var speed = 90
@export var health = 2
@export var xp_square_scene = preload("res://xp_particle.tscn")
@export var min_xp_squares = 2
@export var max_xp_squares = 6

var player = null

func _ready() -> void:
	player = get_parent().get_node("Player")
	$HealthBar.max_value = health
	$HealthBar.value = health
	$HealthBar.visible = false

func _process(delta: float) -> void:
	if player:
		var direction = (player.position - position).normalized()
		velocity = direction * speed * delta * 100
		move_and_slide()

func take_hit() -> void:
	$HealthBar.visible = true
	health -= 1
	$HealthBar.value = health
	if health <= 0:
		die()

func die() -> void:
	var num_xp_squares = randi_range(min_xp_squares, max_xp_squares)
	for i in range(num_xp_squares):
		var xp_square = xp_square_scene.instantiate()
		get_tree().get_root().add_child(xp_square)
		xp_square.position = position
		
		
		# Apply some random movement to each XP square
		var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		var distance = randf_range(50, 100)  # Adjust as needed
		xp_square.target_position = position + direction * distance

	queue_free()
