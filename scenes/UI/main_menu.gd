extends Control

func _on_start_button_pressed():
	Transition.change_scene("res://scenes/puzzles/01_first_link.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
