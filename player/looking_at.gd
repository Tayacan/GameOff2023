class_name LookingAt
extends Node3D

@onready var look_ray = $Camera3D/LookRay
@onready var select_ray = $Camera3D/SelectRay

var obj: PhysicsBody3D = null
var in_grab_range: bool = false

var _look_ray_has_obj: bool = false
var _select_ray_has_obj: bool = false

func started_looking_at(body):
    obj = body

func _on_look_ray_started_looking_at_item(body):
    _look_ray_has_obj = true
    started_looking_at(body)

func _on_look_ray_stopped_looking_at_item(body):
    _look_ray_has_obj = false
    if not _select_ray_has_obj:
        obj = null
    else:
        in_grab_range = false

func _on_select_ray_started_looking_at_item(body):
    _select_ray_has_obj = true
    started_looking_at(body)
    in_grab_range = true

func _on_select_ray_stopped_looking_at_item(body):
    _select_ray_has_obj = false
    if not _look_ray_has_obj:
        obj = null
    in_grab_range = false
