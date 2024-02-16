extends Node3D

@export var links: Array[LinkData]
var link_index = 0

var obj_to_link : PhysicsBody3D = null
var link_obj_1 : PhysicsBody3D = null
var link : Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
    LinkHandling.link_type_changed.emit(links[link_index])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    handle_link_switch()
    handle_clear()
    handle_link()

func handle_link_switch():
    if Input.is_action_just_pressed("change_link_next"):
        link_index = (link_index + 1) % links.size()
        LinkHandling.link_type_changed.emit(links[link_index])
    if Input.is_action_just_pressed("change_link_prev"):
        link_index = (link_index - 1) % links.size()
        LinkHandling.link_type_changed.emit(links[link_index])

func handle_clear():
    if Input.is_action_just_pressed("clear_link") and obj_to_link and obj_to_link.is_in_group("linkable"):
        if obj_to_link.link:
            link = obj_to_link.link
            link.obj_1.remove_link()
            link.obj_1.set_glow_link(link.obj_1.neutral_material)
            link.obj_2.remove_link()
            link.obj_2.set_glow_link(link.obj_1.neutral_material)
            link.queue_free()
            link = null
        else:
            obj_to_link.remove_link()
            obj_to_link.set_glow_link(obj_to_link.neutral_material)
            link_obj_1 = null

func handle_link():
    if Input.is_action_just_pressed("link") and obj_to_link and obj_to_link.is_in_group("linkable"):
        # prevent multiple links on one object
        if obj_to_link.link:
            return
        # Set up new link
        if not link_obj_1:
            link_obj_1 = obj_to_link
            link_obj_1.set_glow_link(links[link_index].material)
        elif obj_to_link != link_obj_1:
            link_obj_1.set_glow_link(links[link_index].material)
            obj_to_link.set_glow_link(links[link_index].material)
            
            link = links[link_index].scene.instantiate()
            link_obj_1.add_link(link)
            obj_to_link.add_link(link)
            link.initialize(link_obj_1, obj_to_link)
            add_child(link)
            link_obj_1 = null

func _on_started_looking_at_item(body: PhysicsBody3D):
    obj_to_link = body

func _on_stopped_looking_at_item(_body):
    obj_to_link = null
