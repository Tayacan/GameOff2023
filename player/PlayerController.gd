extends CharacterBody3D

enum ControlMode { Walking, MovingBox }
var control_mode = ControlMode.Walking

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var footstep_audio = $AudioStreamPlayer

@export var SPEED = 5.0
@export var PUSH_SPEED = 2.5
@export var JUMP_VELOCITY = 4.5
@export var MAX_PUSH_RANGE = 10
var current_speed = 0

@export var mouse_sensitivity = 1
var mouse_move : Vector2 = Vector2(0, 0)

var obj_to_push : AnimatableBody3D = null
var obj_looking_at = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if control_mode == ControlMode.Walking:
			camera_rotation(event.relative)
		elif control_mode == ControlMode.MovingBox:
			moving_box(event.relative)

func _physics_process(delta):
	walking(delta)
	if control_mode == ControlMode.Walking:
	# Mode switching
		if Input.is_action_just_pressed("grab"):
			if obj_looking_at:
				obj_looking_at.select()
				control_mode = ControlMode.MovingBox
	elif control_mode == ControlMode.MovingBox:
		if Input.is_action_just_pressed("grab"):
			obj_looking_at.deselect()
			control_mode = ControlMode.Walking
#		if not obj_looking_at or transform.origin.distance_to(obj_looking_at.transform.origin) > MAX_PUSH_RANGE:
#			if obj_looking_at:
#				obj_looking_at.deselect()
#			control_mode = ControlMode.Walking

func moving_box(mouse_delta):
	var t = Transform3D()
	t.origin = transform.origin
	var target_point = obj_looking_at.transform.origin
	target_point.y = t.origin.y
	t = t.looking_at(target_point)
	var input_dir = mouse_delta
	var direction = (t.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var vel = direction * PUSH_SPEED * 0.005
	
	var old_distance = transform.origin.distance_to(obj_looking_at.transform.origin + obj_looking_at.velocity)
	var new_pos = obj_looking_at.transform.origin + obj_looking_at.velocity + vel
	var new_distance = transform.origin.distance_to(new_pos)
	if new_distance <= MAX_PUSH_RANGE or new_distance <= old_distance:
		obj_looking_at.add_velocity(vel)

func walking(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_pushing(direction) or control_mode == ControlMode.MovingBox:
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
	elif control_mode == ControlMode.MovingBox:
		obj_looking_at.add_velocity(vel)

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


func _on_foot_step_timer_timeout():
	if velocity.length() > 0.2 and is_on_floor():
		footstep_audio.play()


func _on_look_ray_started_looking_at_item(body):
	if control_mode == ControlMode.Walking:
		obj_looking_at = body


func _on_look_ray_stopped_looking_at_item(body):
	if control_mode == ControlMode.Walking and obj_looking_at == body:
		obj_looking_at = null
