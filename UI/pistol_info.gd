extends Control

@export var attack_speed_label : Label
#@onready var attack_speed_button = $"PanelContainer/MarginContainer/VBoxContainer/Attribute Container/Attack Speed Button"
@export var damage_label : Label
@export var range_label : Label
@export var penetration_label : Label
#@export var player : Node2D
var gun = null 
var pause_menu = null
# Called when the node enters the scene tree for the first time.
func _ready():
	gun = get_tree().get_root().get_node("World/Player/Gun")
	pause_menu = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_labels() -> void:
	attack_speed_label.text = "Attack Speed: " + str(gun.shot_cooldown)
	penetration_label.text = "Penetration: " + str(gun.penetration)
	damage_label.text = "Damage: " + str(gun.damage)
	range_label.text = "Range: " + str(gun.gun_range)
	$"PanelContainer/MarginContainer/Upgrade Points".text = "Upgrade Points: " +  str(pause_menu.upgrade_points)
	


func _on_attack_speed_button_pressed():
	if pause_menu.upgrade_points > 0:
		gun.shot_cooldown = gun.shot_cooldown*0.9
		pause_menu.upgrade_points -= 1
		update_labels()
		pause_menu.update()


func _on_damage_button_pressed():
	if pause_menu.upgrade_points > 0:
		gun.damage += 0.2
		pause_menu.upgrade_points -= 1
		update_labels()
		pause_menu.update()


func _on_penetration_button_pressed():
	if pause_menu.upgrade_points > 1 and gun.penetration <= 4:
		gun.penetration += 1
		pause_menu.upgrade_points -= 2
		update_labels()
		pause_menu.update() 


func _on_back_button_pressed():
	hide()
	get_parent().get_child(0).show()


func _on_range_button_pressed():
	if pause_menu.upgrade_points > 1:
		gun.gun_range += 50
		pause_menu.upgrade_points -= 1
		update_labels()
		pause_menu.update()
