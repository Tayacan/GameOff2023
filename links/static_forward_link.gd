extends Node3D

var obj_1 : AnimatableBody3D = null
var obj_2 : AnimatableBody3D = null

var obj_1_vel : Vector3 = Vector3(0, 0, 0)
var obj_2_vel : Vector3 = Vector3(0, 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var combined_vel = obj_1_vel + obj_2_vel
	# test movements
	var col1 = obj_1.move_and_collide(Vector3(combined_vel.x, 0, 0), true)
	var col2 = obj_2.move_and_collide(Vector3(combined_vel.x, 0, 0), true)
	if col1 or col2:
		combined_vel.x = 0
		
	col1 = obj_1.move_and_collide(Vector3(0, combined_vel.y, 0), true)
	col2 = obj_2.move_and_collide(Vector3(0, combined_vel.y, 0), true)
	if col1 or col2:
		combined_vel.y = 0
		
	col1 = obj_1.move_and_collide(Vector3(0, 0, combined_vel.z), true)
	col2 = obj_2.move_and_collide(Vector3(0, 0, combined_vel.z), true)
	if col1 or col2:
		combined_vel.z = 0
	
	obj_1.move_and_collide(combined_vel)
	obj_2.move_and_collide(combined_vel)
	
	obj_1_vel = Vector3(0, 0, 0)
	obj_2_vel = Vector3(0, 0, 0)

func initialize(a: AnimatableBody3D, b: AnimatableBody3D):
	obj_1 = a
	obj_2 = b
	obj_1.wants_move.connect(_on_wants_move_obj1)
	obj_2.wants_move.connect(_on_wants_move_obj2)

func _on_wants_move_obj1(vel: Vector3):
	obj_1_vel = vel

func _on_wants_move_obj2(vel: Vector3):
	obj_2_vel = vel
