extends Control
@onready var pistol_menu_scene = preload("res://UI/pistol_info.tscn")
@export var upgrade_points = 0
@export var player_menu_scene : Control
@export var upgrade_label : Label
@export var level_label : Label
@export var player : Node2D
@onready var shotgun_scene = preload("res://Weapons/shotgun.tscn")
var has_shotgun = false
# Called when the node enters the scene tree for the first time.
func _ready():
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused == true:
			unpause()
		else:
			pause()
			
func unpause():
	get_tree().paused = false
	hide()

func pause():
	get_tree().paused = true
	show()
func level_up() -> void:
	level_label.text = "Level: " + str(player.level)
	upgrade_points += 2
	update()
	visible = true
	get_tree().paused = true

func _on_pistol_button_pressed():
	$PanelContainer.hide()
	$PistolInfo.show()
	$PistolInfo.update_labels()
	

func update() -> void:
	upgrade_label.text = "Upgrade Points: " + str(upgrade_points)


func _on_button_pressed():
	unpause()


func _on_quit_pressed():
	get_tree().quit()


func _on_player_button_pressed():
	$PanelContainer.hide()
	$CharacterInfo.show()
	$CharacterInfo.update_labels()


func _on_shotgun_button_pressed():
	if has_shotgun == false and upgrade_points >= 5:
		upgrade_points -= 5
		has_shotgun = true
		update()
		for n in $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer3/ShotgunButton.get_children():
			remove_child(n)
			n.queue_free()
		$PanelContainer/MarginContainer/HBoxContainer/VBoxContainer3/ShotgunButton.text = 'Shotgun'
		$PanelContainer/MarginContainer/HBoxContainer/VBoxContainer3/ShotgunButton.disabled = true
		var shotgun = shotgun_scene.instantiate()
		player.add_child(shotgun)
