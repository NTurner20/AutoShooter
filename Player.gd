extends CharacterBody2D

@export var speed = 250
@export var bullet_scene = preload("res://Weapons/Bullet.tscn")
var level_up_sound = preload("res://assets/Retro PowerUP 09.wav")
var damage_sound = preload("res://assets/Retro Negative Short 23.wav")
var pickup_sound = preload("res://assets/Pickup.wav")
@export var shoot_interval = 2
@export var health: float = 100.0

var speed_modifier = 1
var armor: float = 0.0
var invincible = false
var xp = 0
var level = 1
var xp_next_level = 10
var pause_menu = null
var max_health = 100
var health_regen: float = 0
var health_regen_max = 5
var movements_bounds = Vector2(1000,1000)*512


func _ready():
	#if get_parent().name != 'Test':
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
		health += health_regen/3000
		
	
func level_up():
	xp = 0
	xp_next_level = round(1.3 * xp_next_level)
	print(xp_next_level)
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
		$SFX.stream = pickup_sound
		$SFX.play()
		xp += 1
		area.get_parent().queue_free()
		if xp >= xp_next_level:
			level_up()
	elif area.is_in_group('health'):
		$SFX.stream = pickup_sound
		$SFX.play()
		health += area.health
		if health >= max_health:
			health = max_health
		area.queue_free()

func get_shot(area):
	if not invincible:
			invincible = true
			$Sprite2D/AnimationPlayer.play("flash")
			health -= round(area.damage - armor/2)
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
