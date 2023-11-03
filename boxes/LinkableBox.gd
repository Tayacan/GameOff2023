extends AnimatableBody3D

var linked_obj = null
var velocity: Vector3 = Vector3(0, 0, 0)
var link_velocity: Vector3 = Vector3(0, 0, 0)

func _physics_process(_delta):
	if linked_obj:
		linked_obj.link_velocity = velocity
		link_velocity = linked_obj.velocity
	


func add_link(obj: Node3D):
	linked_obj = obj

func remove_link():
	linked_obj = null

func add_velocity(vel: Vector3):
	velocity += vel
