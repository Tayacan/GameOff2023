extends CharacterBody3D

@onready var head = $Head
@onready var camera = $Head/Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var mouse_sensitivity = 0.05
var mouse_move : Vector2 = Vector2(0, 0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event is InputEventMouseMotion:
		mouse_move = event.relative

func _physics_process(delta):
	# Mouse mode
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	camera_rotation(mouse_move, delta)
	mouse_move.x = 0
	mouse_move.y = 0
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 2)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 2)

	move_and_slide()

func camera_rotation(mouse_move: Vector2, delta: float):
	head.rotate_y(-mouse_move.x * mouse_sensitivity * delta)
	camera.rotate_x(-mouse_move.y * mouse_sensitivity * delta)
	camera.rotation.x = clamp(
		camera.rotation.x,
		-1,
		1
	)
