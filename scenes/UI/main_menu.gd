extends Control

func _on_start_button_pressed():
	Transition.change_scene("res://scenes/playground.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
