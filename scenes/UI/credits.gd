extends Control

@onready var back_button = $PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer4/BackButton

func _ready():
    back_button.grab_focus()

func _on_back_button_pressed():
    Transition.change_scene("res://scenes/UI/main_menu.tscn")
