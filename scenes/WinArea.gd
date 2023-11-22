extends Node

signal win_area_entered

func _on_area_3d_body_entered(body):
    if body.is_in_group("linkable"):
        win_area_entered.emit()
