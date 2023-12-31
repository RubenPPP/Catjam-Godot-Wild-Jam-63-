extends Control

@onready var panelContainer = get_node("PanelContainer")
@onready var levelsList = get_node("PanelContainer/Levels")
@onready var credits = get_node("PanelContainer/Credits")
@onready var title = get_node("Title")
@onready var version = get_node("Version")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_credits_pressed():
	if levelsList.visible:
		levelsList.visible = false
		credits.visible = true
	else:
		panelContainer.visible = not panelContainer.visible
		credits.visible = not credits.visible
		levelsList.visible = false
	if levelsList.visible or credits.visible:
		title.visible = false
		version.visible = false
	else:
		title.visible = true
		version.visible = true

func _on_play_pressed():
	if credits.visible:
		credits.visible = false
		levelsList.visible = true
	else:
		panelContainer.visible = not panelContainer.visible
		levelsList.visible = not levelsList.visible
	if levelsList.visible or credits.visible:
		title.visible = false
		version.visible = false
	else:
		title.visible = true
		version.visible = true

func _on_levels_item_clicked(index, at_position, mouse_button_index):
	if index == 0:
		get_tree().change_scene_to_file("res://Scenes/tutorial.tscn")
	elif index == 1:
		get_tree().change_scene_to_file("res://Scenes/level1.tscn")
	elif index == 2:
		get_tree().change_scene_to_file("res://Scenes/level2.tscn")
	elif index == 3:
		get_tree().change_scene_to_file("res://Scenes/level3.tscn")
	pass # Replace with function body.
