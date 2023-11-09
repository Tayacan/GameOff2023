extends MeshInstance3D

@export_file() var next_level = "res://scenes/UI/winscreen.tscn"

func _on_area_3d_body_entered(body):
	if body.is_in_group("linkable"):
		Transition.change_scene(next_level)
