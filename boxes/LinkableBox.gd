extends AnimatableBody3D

@export var mass : float = 1

var link = null
var velocity: Vector3 = Vector3(0, 0, 0)

var neutral_material: StandardMaterial3D = preload("res://materials/glowing_panels/neutral.tres")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var y_vel = 0

signal wants_move(velocity: Vector3)

func _ready():
    set_glow_focus(neutral_material)

func _physics_process(delta):
    apply_gravity(delta)
    if link:
        wants_move.emit(velocity)
    else:
        var col = move_and_collide(Vector3(velocity.x, 0, 0), true)
        if col:
            velocity.x = 0
        col = move_and_collide(Vector3(0, velocity.y, 0), true)
        if col:
            velocity.y = 0
            y_vel = 0
        col = move_and_collide(Vector3(0, 0, velocity.z), true)
        if col:
            velocity.z = 0
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

func set_glow_focus(material: StandardMaterial3D):
    for child in get_children():
        if child.has_method('set_glow_focus'):
            child.set_glow_focus(material)

func get_glow_focus() -> StandardMaterial3D:
    for child in get_children():
        if child.has_method('get_glow_focus'):
            return child.get_glow_focus()
    return null

func set_glow_link(material: StandardMaterial3D):
    for child in get_children():
        if child.has_method('set_glow_link'):
            child.set_glow_link(material)

func get_glow_link() -> StandardMaterial3D:
    for child in get_children():
        if child.has_method('get_glow_link'):
            return child.get_glow_link()
    return null

func select():
    $SelectSphere.show()

func deselect():
    $SelectSphere.hide()
