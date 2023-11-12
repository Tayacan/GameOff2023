extends Control

@onready var continue_button = $PanelContainer/HBoxContainer4/Menu/HBoxContainer3/ContinueButton

func _ready():
	if FileAccess.file_exists("user://savegame.save"):
		continue_button.show()
		continue_button.pressed.connect(_on_continue_button_pressed)

func _on_start_button_pressed():
	Transition.change_scene("res://scenes/puzzles/01_first_link.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_continue_button_pressed():
	var save = FileAccess.open("user://savegame.save", FileAccess.READ)
	var scene = save.get_line().strip_edges()
	print_debug(scene)
	Transition.change_scene(scene)
