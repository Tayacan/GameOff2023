extends MeshInstance3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("linkable"):
		Transition.change_scene("res://scenes/UI/winscreen.tscn")
