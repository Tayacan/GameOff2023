extends Control

@onready var menu_button = $PanelContainer/VBoxContainer/HBoxContainer/MenuButton

# Called when the node enters the scene tree for the first time.
func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    menu_button.grab_focus()

func _on_menu_button_pressed():
    get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
