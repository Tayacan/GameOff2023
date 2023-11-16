extends Node3D

@onready var box: AnimatableBody3D = $".."

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var y_vel = 0

func _ready():
    process_physics_priority = 1

func _physics_process(delta):
    y_vel += -gravity * delta
    var collision = box.move_and_collide(Vector3(0, y_vel*delta, 0),true)
    if collision:
        var point = collision.get_position()
        y_vel = -box.transform.origin.distance_to(point)
        y_vel = 0
    else:
        box.velocity.y = y_vel*delta
    
    box.move_and_collide(box.velocity + box.link_velocity)
    box.velocity = Vector3(0, 0, 0)
    box.link_velocity = Vector3(0, 0, 0)
