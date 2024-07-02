extends CharacterBody2D

@export var speed = 200
@export var bullet_scene = preload("res://Bullet.tscn")
@export var shoot_interval = 2

var speed_modifier = 1
var time_since_last_shot = 0
var xp = 0

func _ready():
	position = Vector2(
		randf_range(0,  1000),
		randf_range(0, 1000)
	)

func _process(delta):
	var input_direction = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		input_direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_direction.y += 1
	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		input_direction.x += 1
		
	if input_direction != Vector2.ZERO:
		rotation = input_direction.angle() + deg_to_rad(90)
	velocity = input_direction.normalized() * speed * speed_modifier * 100 * delta 
	move_and_slide()
	
	time_since_last_shot += delta
	if time_since_last_shot >= shoot_interval:
		shoot()
		time_since_last_shot = 0
		
func shoot() -> void:
	var nearest_enemy = find_nearest_enemy()
	if nearest_enemy:
		var bullet = bullet_scene.instantiate()
		bullet.position = position
		var direction = (nearest_enemy.position - position).normalized()
		bullet.initialize(direction)
		get_parent().add_child(bullet)

func find_nearest_enemy() -> Node2D:
	var nearest_enemy = null
	var shortest_distance = INF
	for enemy in get_parent().get_children():
		if enemy.is_in_group("enemies"):
			var distance = position.distance_to(enemy.position)
			if distance < shortest_distance:
				shortest_distance = distance
				nearest_enemy = enemy
	return nearest_enemy	





func _on_pickup_area_area_entered(area):
	if area.is_in_group('xp'):
		xp += 1
		area.get_parent().queue_free()
