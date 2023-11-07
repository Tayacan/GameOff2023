extends AnimatableBody3D

@export var mass : float = 1

var link = null
var velocity: Vector3 = Vector3(0, 0, 0)

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var y_vel = 0

signal wants_move(velocity: Vector3)

func _physics_process(delta):
	apply_gravity(delta)
	if link:
		wants_move.emit(velocity)
	else:
		move_and_collide(velocity)
	
	velocity = Vector3(0, 0, 0)

func apply_gravity(delta):
	y_vel += -gravity * delta
	var collision = move_and_collide(Vector3(0, y_vel*delta, 0),true)
	if collision:
		var point = collision.get_position()
		y_vel = -transform.origin.distance_to(point)
	else:
		velocity.y = y_vel*delta

func add_link(new_link: Node3D):
	link = new_link

func remove_link():
	link = null

func add_velocity(vel: Vector3):
	velocity += vel
