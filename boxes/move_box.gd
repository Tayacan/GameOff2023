extends Node3D

@onready var box = $".."

func _ready():
	process_physics_priority = 1

func _physics_process(_delta):
	box.move_and_collide(box.velocity + box.link_velocity)
	box.velocity = Vector3(0, 0, 0)
	box.link_velocity = Vector3(0, 0, 0)
