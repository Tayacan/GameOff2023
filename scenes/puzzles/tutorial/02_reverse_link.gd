extends Node3D

@export_file("*.tscn") var next_level : String

func _on_win_area_2_win_area_entered():
    Transition.change_scene(next_level)
