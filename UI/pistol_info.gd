extends Control

@export var attack_speed_label : Label
#@onready var attack_speed_button = $"PanelContainer/MarginContainer/VBoxContainer/Attribute Container/Attack Speed Button"
@export var damage_label : Label
@export var range_label : Label
@export var penetration_label : Label
@onready var sfx = $"../SFX"
var upgrade_sound = preload("res://assets/Retro Event Acute 11.wav")
#@export var player : Node2D
var gun = null 
var pause_menu = null
# Called when the node enters the scene tree for the first time.
func _ready():
	gun = get_tree().get_root().get_node("World/Player/Gun")
	pause_menu = get_parent()



func update_labels() -> void:
	attack_speed_label.text = "Attack Speed: " + str(gun.shot_cooldown)
	if gun.penetration > 4:
		penetration_label.text = "Penetration: MAX"
	else:
		penetration_label.text = "Penetration: " + str(gun.penetration)
	damage_label.text = "Damage: " + str(gun.damage)
	range_label.text = "Range: " + str(gun.gun_range)
	$"PanelContainer/MarginContainer/Upgrade Points".text = "Upgrade Points: " +  str(pause_menu.upgrade_points)
	


func _on_attack_speed_button_pressed():
	
	if pause_menu.upgrade_points > 0:
		sfx.stream = upgrade_sound
		sfx.play()
		gun.shot_cooldown = gun.shot_cooldown*0.9
		gun.shot_cooldown = snapped(gun.shot_cooldown,0.01)
		pause_menu.upgrade_points -= 1
		update_labels()
		pause_menu.update()


func _on_damage_button_pressed():
	if pause_menu.upgrade_points > 0:
		sfx.stream = upgrade_sound
		sfx.play()
		gun.damage += 0.2
		pause_menu.upgrade_points -= 1
		update_labels()
		pause_menu.update()


func _on_penetration_button_pressed():
	if pause_menu.upgrade_points > 1 and gun.penetration < 5:
		sfx.stream = upgrade_sound
		sfx.play()
		gun.penetration += 1
		pause_menu.upgrade_points -= 2
		update_labels()
		pause_menu.update() 


func _on_back_button_pressed():
	hide()
	get_parent().get_child(0).show()


func _on_range_button_pressed():
	if pause_menu.upgrade_points > 0:
		sfx.stream = upgrade_sound
		sfx.play()
		gun.gun_range += 50
		pause_menu.upgrade_points -= 1
		update_labels()
		pause_menu.update()
