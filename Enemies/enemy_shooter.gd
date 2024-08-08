extends CharacterBody2D

var player = null
@export var target_distance = 450
@export var distance_margin = 60
@export var speed = 160
@export var shoot_cooldown: float = 3.0
@export var health_drop_scene = preload("res://health_drop.tscn")
@export var xp_square_scene = preload("res://xp_particle.tscn")
var time_since_last_shot = 0.0
@export var bullet_scene = preload("res://Enemies/enemy_bullet.tscn")
var last_shot_time = 0
@export var health = 10
@export var min_xp_squares = 2
@export var max_xp_squares = 10
@export var damage = 5

func _ready():
	player = get_parent().get_node("Player")
	$HealthBar.max_value = health
	$HealthBar.value = health
	$HealthBar.visible = false
func _physics_process(delta):
	time_since_last_shot += delta

	if player:
		var distance_to_player = position.distance_to(player.position)
		if abs(distance_to_player - target_distance) <= distance_margin:
			if time_since_last_shot >= shoot_cooldown:
				shoot_at_player()
				time_since_last_shot = 0.0
		else:
			var direction = (position - player.position).normalized()
			if distance_to_player > target_distance:
				velocity = -direction * speed
				rotation = direction.angle() - deg_to_rad(90)
			else:
				velocity = direction * speed
				$Sprite2D.rotation = direction.angle() + deg_to_rad(90)
			move_and_slide()
				
func shoot_at_player():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	var direction = (player.position - position).normalized()
	bullet.initialize(direction)
	get_parent().add_child(bullet)
	
func take_hit(taken_damage):
	health -= taken_damage
	if health <= 0:
		die()
	$HealthBar.value = health
	$HealthBar.visible = true
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
	var healthdrop = randi_range(0,9) # 1 in 10 chance
	if healthdrop == 0:
		var health_drop = health_drop_scene.instantiate()
		get_tree().get_root().add_child(health_drop)
		health_drop.position = position
	queue_free()
