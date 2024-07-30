extends Control

@export var attack_speed_label : Label
@export var damage_label : Label
@export var range_label : Label
@export var spread_label : Label

@export var max_spread = 5

var gun = null 
var pause_menu = null
@onready var sfx = $"../SFX"
var upgrade_sound = preload("res://assets/Retro Event Acute 11.wav")
# Called when the node enters the scene tree for the first time.
func _ready():
	pause_menu = get_parent()
	update_labels()
func update_labels() -> void:
	if gun:
		if gun.shot_cooldown <= 0.1:
			attack_speed_label.text = "Attack Speed: MAX"
		else:
			attack_speed_label.text = "Attack Speed: " + str(gun.shot_cooldown)
		if gun.get_children()[0].spread >= 5:
			spread_label.text = "Spread: MAX"
		else:
			spread_label.text = "Spread: " + str(gun.get_children()[0].spread)
		damage_label.text = "Damage: " + str(gun.damage)
		range_label.text = "Range: " + str(gun.gun_range)
	$"PanelContainer/MarginContainer/Upgrade Points".text = "Upgrade Points: " +  str(pause_menu.upgrade_points)
	

func get_shotgun():
	gun = get_tree().get_root().get_node("World/Player/Shotgun")
	
func _on_attack_speed_button_pressed():
	if pause_menu.upgrade_points > 0 and gun.shot_cooldown > 0.1:
		sfx.stream = upgrade_sound
		sfx.play()
		gun.shot_cooldown = gun.shot_cooldown - 0.1
		pause_menu.upgrade_points -= 1
		update_labels()
		pause_menu.update()


func _on_damage_button_pressed():
	if pause_menu.upgrade_points > 0:
		sfx.stream = upgrade_sound
		sfx.play()
		gun.damage += 0.1
		pause_menu.upgrade_points -= 1
		update_labels()
		pause_menu.update()


func _on_spread_button_pressed():
	if pause_menu.upgrade_points > 2  and gun.get_children()[0].spread < max_spread:
		sfx.stream = upgrade_sound
		sfx.play()
		gun.get_children()[0].spread += 1
		pause_menu.upgrade_points -= 3
		update_labels()
		pause_menu.update() 


func _on_back_button_pressed():
	hide()
	get_parent().get_child(0).show()


func _on_range_button_pressed():
	if pause_menu.upgrade_points > 0:
		sfx.stream = upgrade_sound
		sfx.play()
		gun.gun_range += 25
		pause_menu.upgrade_points -= 1
		update_labels()
		pause_menu.update()
