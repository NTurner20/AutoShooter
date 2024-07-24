extends CharacterBody2D

@export var speed = 250
@export var bullet_scene = preload("res://Weapons/Bullet.tscn")
var level_up_sound = preload("res://assets/Retro PowerUP 09.wav")
var damage_sound = preload("res://assets/Retro Negative Short 23.wav")
@export var shoot_interval = 2
@export var health = 100

var spread = 1
var max_spread = 3
var speed_modifier = 1
var armor = 0
var damage = 1
var invincible = false
var time_since_last_shot = 0
var xp = 0
var level = 1
var xp_next_level = 10
var pause_menu = null
var max_health = 100
var range = 1000
var health_regen = 0
var health_regen_max = 5
var movements_bounds = Vector2(1000,1000)*512


func _ready():
	if get_parent().name != 'Test':
		position = Vector2(
			randf_range(0,  100*512),
			randf_range(0, 100*512)
		)
		pause_menu = get_tree().get_root().get_node("World/UI/PauseMenu")

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
	velocity = input_direction.normalized() * speed * speed_modifier * delta 
	var new_position = position + velocity
	new_position.x = clamp(new_position.x,0,movements_bounds.x)
	new_position.y = clamp(new_position.y,0,movements_bounds.y)
	position = new_position
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()
		take_hit(body)
	# health regen
	if health < max_health:
		health += health_regen/400
	time_since_last_shot += delta
	if time_since_last_shot >= shoot_interval:
		#shoot()
		time_since_last_shot = 0
		
#func shoot() -> void:
	#var nearest_enemy = find_nearest_enemy()
	#if nearest_enemy:
		#if spread > 1:
			#for i in range(spread):
				#var bullet = bullet_scene.instantiate()
				#bullet.damage = damage
				#bullet.position = position
				#var base_direction  = (nearest_enemy.position - position).normalized()
				## Calculate angle offset
				#var angle_offset = (i - (spread - 1) / 2.0) * 0.1  # Adjust the spread angle factor as needed
			#
				## Rotate the base direction by the angle offset
				#var rotated_direction = base_direction.rotated(angle_offset)
#
				#bullet.initialize(rotated_direction)
				#get_parent().add_child(bullet)
		#else:
			#var bullet = bullet_scene.instantiate()
			#bullet.damage = damage
			#bullet.position = position
			#var direction = (nearest_enemy.position - position).normalized()
			#bullet.initialize(direction)
			#get_parent().add_child(bullet)
#
#func find_nearest_enemy() -> Node2D:
	#var nearest_enemy = null
	#var shortest_distance = INF
	#for enemy in get_parent().get_children():
		#if enemy.is_in_group("enemies"):
			#var distance = position.distance_to(enemy.position)
			#if distance > range:
				#return nearest_enemy
			#if distance < shortest_distance:
				#shortest_distance = distance
				#nearest_enemy = enemy
	#return nearest_enemy	
	
func level_up():
	xp = 0
	xp_next_level = 1.25 * xp_next_level
	level = level + 1
	pause_menu.level_up()
	$SFX.stream = level_up_sound
	$SFX.play()
	

func take_hit(body):
	if body.is_in_group("enemies"):
		if not invincible:
			$SFX.stream = damage_sound
			$SFX.play()
			invincible = true
			$Sprite2D/AnimationPlayer.play("flash")
			health -= (body.damage - armor/2)
			$CollisionShape2D.disabled = true
			$Invincible.start()
			if health <= 0:
				die()
	if body.is_in_group("enemy_bullets"):
		if not invincible:
			invincible = true
			$Sprite2D/AnimationPlayer.play("flash")
			health -= (body.damage - armor/2)
			$CollisionShape2D.disabled = true
			$Invincible.start()
			if health <= 0:
				die()
			body.queue_free()
			$SFX.stream = damage_sound
			$SFX.play()
	
		



func _on_pickup_area_area_entered(area):
	if area.is_in_group('xp'):
		xp += 1
		area.get_parent().queue_free()
		if xp >= xp_next_level:
			level_up()
	elif area.is_in_group('health'):
		health += area.health
		if health >= max_health:
			health = max_health
		area.queue_free()

func get_shot(area):
	if not invincible:
			invincible = true
			$Sprite2D/AnimationPlayer.play("flash")
			health -= (area.damage - armor/2)
			$CollisionShape2D.disabled = true
			$Invincible.start()
			if health <= 0:
				die()
			area.queue_free()
			
func _on_invincible_timeout():

	$CollisionShape2D.disabled = false
	invincible = false
	$Sprite2D/AnimationPlayer.play("RESET")
func die():
	get_tree().paused = true
	var gameOver = get_tree().get_root().get_node("World/UI/GameOver")
	gameOver.visible = true


func _on_health_regen_timeout():
	if health < max_health:
		health+=health_regen
		if health > max_health:
			health = max_health
