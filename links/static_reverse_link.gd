extends Node3D

var obj_1 : AnimatableBody3D = null
var obj_2 : AnimatableBody3D = null

var obj_1_vel : Vector3 = Vector3(0, 0, 0)
var obj_2_vel : Vector3 = Vector3(0, 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
    # Lighter object does not get a say when it comes to gravity
    if obj_1.mass > obj_2.mass:
        obj_2.y_vel = 0
        obj_2_vel.y = 0
    elif obj_2.mass > obj_1.mass:
        obj_1.y_vel = 0
        obj_1_vel.y = 0
    else:
        obj_2.y_vel = 0
        obj_2_vel.y = 0
        obj_1.y_vel = 0
        obj_1_vel.y = 0
        
        
    # Calculate velocities
    var combined_vel_1 = obj_1_vel - (obj_2_vel * (obj_2.mass / obj_1.mass))
    var combined_vel_2 = obj_2_vel - (obj_1_vel * (obj_1.mass / obj_2.mass))
    
    # test movements one axis at a time
    var col1 = obj_1.move_and_collide(Vector3(combined_vel_1.x, 0, 0), true)
    var col2 = obj_2.move_and_collide(Vector3(combined_vel_2.x, 0, 0), true)
    if col1 or col2:
        combined_vel_1.x = 0
        combined_vel_2.x = 0
    
    col1 = obj_1.move_and_collide(Vector3(0, combined_vel_1.y, 0), true)
    col2 = obj_2.move_and_collide(Vector3(0, combined_vel_2.y, 0), true)
    if col1 or col2:
        combined_vel_1.y = 0
        combined_vel_2.y = 0
        # Y axis is special: Reset acceleration if object did not move on y axis
        obj_1.y_vel = 0
        obj_2.y_vel = 0
        
    col1 = obj_1.move_and_collide(Vector3(0, 0, combined_vel_1.z), true)
    col2 = obj_2.move_and_collide(Vector3(0, 0, combined_vel_2.z), true)
    if col1 or col2:
        combined_vel_1.z = 0
        combined_vel_2.z = 0
    
    # Actually move
    obj_1.move_and_collide(combined_vel_1)
    obj_2.move_and_collide(combined_vel_2)

func initialize(a: AnimatableBody3D, b: AnimatableBody3D):
    obj_1 = a
    obj_2 = b
    obj_1.wants_move.connect(_on_wants_move_obj1)
    obj_2.wants_move.connect(_on_wants_move_obj2)

func _on_wants_move_obj1(vel: Vector3):
    obj_1_vel = vel

func _on_wants_move_obj2(vel: Vector3):
    obj_2_vel = vel
