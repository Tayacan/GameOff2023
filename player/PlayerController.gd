extends CharacterBody3D

@onready var head = $Head
@onready var camera = $Head/Camera3D

@export var SPEED = 5.0
@export var PUSH_SPEED = 2.5
@export var JUMP_VELOCITY = 4.5
var current_speed = 0

@export var mouse_sensitivity = 1
var mouse_move : Vector2 = Vector2(0, 0)

var obj_to_push : AnimatableBody3D = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		camera_rotation(event.relative)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_pushing(direction):
		current_speed = PUSH_SPEED
	else:
		current_speed = SPEED
	
	var current_position = transform.origin
	if is_on_floor():
		velocity.x = lerp(velocity.x, direction.x * current_speed, delta * 20)
		velocity.z = lerp(velocity.z, direction.z * current_speed, delta * 20)
	else:
		velocity.x = lerp(velocity.x, direction.x * current_speed, delta * 2)
		velocity.z = lerp(velocity.z, direction.z * current_speed, delta * 2)
	
	move_and_slide()
	push(transform.origin - current_position)

func camera_rotation(mouse_delta: Vector2):
	head.rotate_y(-mouse_delta.x * mouse_sensitivity * 0.001)
	camera.rotate_x(-mouse_delta.y * mouse_sensitivity * 0.001)
	camera.rotation.x = clamp(
		camera.rotation.x,
		-1.1,
		1.1
	)

func push(vel: Vector3):
	if is_pushing(vel):
			obj_to_push.add_velocity(vel)

func is_pushing(dir: Vector3) -> bool:
	if obj_to_push and obj_to_push.has_method("add_velocity"):
		var direction_to_obj = transform.origin.direction_to(obj_to_push.transform.origin)
		var d = dir.normalized().dot(direction_to_obj)
		return d > 0.5
	return false

func _on_body_entered_push_area(body):
	if body is AnimatableBody3D:
		obj_to_push = body as AnimatableBody3D

func _on_body_exited_push_area(body):
	if body is AnimatableBody3D:
		obj_to_push = null
