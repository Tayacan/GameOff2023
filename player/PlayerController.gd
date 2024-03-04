extends CharacterBody3D

enum ControlMode { Walking, MovingBox }
var control_mode = ControlMode.Walking

@onready var head: LookingAt = $Head
@onready var camera = $Head/Camera3D
@onready var footstep_audio = $FootstepAudio

@export var SPEED = 5.0
@export var PUSH_SPEED = 3.5
@export var JUMP_VELOCITY = 4.5
@export var MAX_PUSH_RANGE = 10
@export var LOOK_ANGLE_THRESHOLD_RADIANS = 0.6
var current_speed = 0

@export var mouse_sensitivity = 1
const mouse_factor = 0.001

@export var gamepad_sensitivity = 1
const gamepad_factor = 0.05

var obj_to_push : AnimatableBody3D = null
var selected_object : AnimatableBody3D = null
var obj_dist : float = 0

var mouse_delta := Vector2(0, 0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
    if event is InputEventMouseMotion:
        mouse_delta += event.relative

func _physics_process(delta):
    walking(delta)
    if selected_object and not still_looking():
        control_mode = ControlMode.Walking
        selected_object.deselect()
        selected_object = null
    if control_mode == ControlMode.Walking:
        if InputDevice.device == InputDevice.Device.KEYBOARD:
            camera_rotation(mouse_delta)
        else:
            gamepad_rotation()
        mouse_delta = Vector2(0, 0)
        # Mode switching
        if Input.is_action_just_pressed("grab"):
            if head.obj and head.in_grab_range:
                selected_object = head.obj
                selected_object.select()
                obj_dist = transform.origin.distance_to(selected_object.transform.origin)
                control_mode = ControlMode.MovingBox
    elif control_mode == ControlMode.MovingBox:
        var desired_x_angle = 0
        var desired_y_angle = 0
        if InputDevice.device == InputDevice.Device.KEYBOARD:
            desired_x_angle = -mouse_delta.x * mouse_sensitivity * mouse_factor
            desired_y_angle = -mouse_delta.y * mouse_sensitivity * mouse_factor
        else:
            var dir = get_gamepad_dir()
            desired_x_angle = -dir.x * gamepad_sensitivity * gamepad_factor
            desired_y_angle = dir.y * gamepad_sensitivity * gamepad_factor
        var max_box_move = PUSH_SPEED * delta
        var dist = transform.origin.distance_to(selected_object.transform.origin)

        var angle = desired_x_angle
        var desired_move = angle * dist
        if abs(desired_move) > max_box_move:
            angle = sign(desired_move) * max_box_move / dist
        
        camera_rotation_angles(angle, desired_y_angle)
        box_move(angle)
        mouse_delta = Vector2(0, 0)
        
        # Mode switching
        if Input.is_action_just_pressed("grab"):
            selected_object.deselect()
            selected_object = null
            control_mode = ControlMode.Walking

func box_move(angle_radians: float):
    var box_position = selected_object.transform.origin
    var dir = box_position - transform.origin
    var rotated_dir = dir.rotated(Vector3(0, 1, 0), angle_radians)
    var new_position = transform.origin + rotated_dir
    selected_object.add_velocity(new_position - box_position)

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

func camera_rotation(delta: Vector2):
    camera_rotation_angles(-delta.x * mouse_sensitivity * mouse_factor,
                           -delta.y * mouse_sensitivity * mouse_factor)

func get_gamepad_dir() -> Vector2:
    var dir = Input.get_vector("gamepad_rotate_left",
                               "gamepad_rotate_right",
                               "gamepad_rotate_down",
                               "gamepad_rotate_up")
    var len = dir.length() ** 2
    return dir.normalized() * len

func gamepad_rotation():
    var dir = get_gamepad_dir()
    camera_rotation_angles(-dir.x * gamepad_sensitivity * gamepad_factor,
                           dir.y * gamepad_sensitivity * gamepad_factor)

func camera_rotation_angles(angle_y : float, angle_x : float):
    head.rotate_y(angle_y)
    camera.rotate_x(angle_x)
    camera.rotation.x = clamp(
        camera.rotation.x,
        -1.1,
        1.1
    )

func push(vel: Vector3):
    if is_pushing(vel):
        obj_to_push.add_velocity(vel)
    elif control_mode == ControlMode.MovingBox:
        selected_object.add_velocity(vel)

func is_pushing(dir: Vector3) -> bool:
    if obj_to_push and obj_to_push.has_method("add_velocity"):
        var direction_to_obj = transform.origin.direction_to(obj_to_push.transform.origin)
        var d = dir.normalized().dot(direction_to_obj)
        return d > 0.5
    return false

func still_looking() -> bool:
    if head.obj and head.in_grab_range:
        return true
    elif selected_object:
        var look_dir = -head.transform.basis.z
        var dir_to_obj = transform.origin.direction_to(selected_object.transform.origin)
        look_dir.y = 0
        dir_to_obj.y = 0
        var angle = look_dir.angle_to(dir_to_obj)
        return angle < LOOK_ANGLE_THRESHOLD_RADIANS
    else:
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

