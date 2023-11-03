extends AnimatableBody3D

var linked_obj = null
var current_position: Vector3
var delta_position: Vector3

func _ready():
	current_position = transform.origin

func _physics_process(delta):
	delta_position = transform.origin - current_position
	current_position = transform.origin
	
	if linked_obj and delta_position.length() > 0.01:
		linked_obj.move_and_collide(delta_position)

func add_link(obj: Node3D):
	linked_obj = obj
