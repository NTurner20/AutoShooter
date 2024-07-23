extends Control
@export var movement_speed_label : Label
@export var armor_label : Label
@export var health_regen_label : Label
@export var max_health_label : Label
@export var player : Node2D
var pause_menu = null
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pause_menu = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_labels() -> void:
	if player.speed_modifier >= 1.5:
		movement_speed_label.text = "Movement Speed: MAX" 
	else:
		movement_speed_label.text = "Movement Speed: " + str(player.speed_modifier) 
	if player.health_regen >= player.health_regen_max:
		health_regen_label.text = "Health Regen: MAX"
	else:
		health_regen_label.text = "Health Regen: " + str(player.health_regen)
	armor_label.text = "Armor: " + str(player.armor)
	
	max_health_label.text = "Max Health: " + str(player.max_health)
	$"PanelContainer/MarginContainer/Upgrade Points".text = "Upgrade Points: " +  str(pause_menu.upgrade_points)
	

func _on_movement_speed_button_pressed():
	if pause_menu.upgrade_points > 0 and player.speed_modifier <= 1.5:
		player.speed_modifier *= 1.1
		player.speed_modifier = snapped(player.speed_modifier,0.01)
		apply_upgrade(1)


func _on_health_regen_button_pressed():
	if pause_menu.upgrade_points > 0:
		player.health_regen += 1
		apply_upgrade(1)
		

func apply_upgrade(points:int):
	pause_menu.upgrade_points -= points
	update_labels()
	pause_menu.update()

func _on_armor_button_pressed():
	if pause_menu.upgrade_points > 0:
		player.armor += 1
		apply_upgrade(1)


func _on_max_health_button_pressed():
	if pause_menu.upgrade_points > 0:
		player.max_health += 10
		apply_upgrade(1)


func _on_back_button_pressed():
	hide()
	get_parent().get_child(0).show()
