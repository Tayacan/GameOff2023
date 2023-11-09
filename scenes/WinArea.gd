extends MeshInstance3D

@onready var timer: Timer = $Timer

func _on_area_3d_body_entered(body):
	if body.is_in_group("linkable"):
		timer.start()

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/UI/winscreen.tscn")
