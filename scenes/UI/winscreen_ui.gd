extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_menu_button_pressed():
    get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
