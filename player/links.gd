extends Node3D

var link_type : LinkHandling.LinkType = LinkHandling.LinkType.Forward
var obj_to_link : PhysicsBody3D = null
var link_obj_1 : PhysicsBody3D = null
var link_obj_2 : PhysicsBody3D = null
var l1_indicator : Node3D = null
var l2_indicator : Node3D = null
var link : Node3D = null

var indicator : PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	indicator = preload("res://links/link_indicator.tscn")
	LinkHandling.link_type_changed.emit(link_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handle_link_switch()
	handle_clear()
	handle_link()

func handle_link_switch():
	if Input.is_action_just_pressed("change_link_next"):
		link_type = LinkHandling.next_link_type(link_type)
		LinkHandling.link_type_changed.emit(link_type)
	if Input.is_action_just_pressed("change_link_prev"):
		link_type = LinkHandling.prev_link_type(link_type)
		LinkHandling.link_type_changed.emit(link_type)

func handle_clear():
	if Input.is_action_just_pressed("clear_link"):
		if link_obj_1:
			l1_indicator.queue_free()
			link_obj_1.remove_link()
			link_obj_1 = null
		if link_obj_2:
			l2_indicator.queue_free()
			link_obj_2.remove_link()
			link_obj_2 = null
		if link:
			link.queue_free()
			link = null

func handle_link():
	if Input.is_action_just_pressed("link") and obj_to_link and obj_to_link.is_in_group("linkable"):
		# Remove old link if there is one
		if link:
			l1_indicator.queue_free()
			l2_indicator.queue_free()
			link_obj_1.remove_link()
			link_obj_2.remove_link()
			link_obj_1 = null
			link_obj_2 = null
			link.queue_free()
			link = null
		
		# Set up new link
		if not link_obj_1:
			l1_indicator = indicator.instantiate()
			l1_indicator.mesh.material = make_indicator_material()
			obj_to_link.add_child(l1_indicator)
			link_obj_1 = obj_to_link
		else:
			link_obj_2 = obj_to_link
			l1_indicator.queue_free()
			l1_indicator = indicator.instantiate()
			l1_indicator.mesh.material = make_indicator_material(true)
			l2_indicator = indicator.instantiate()
			l2_indicator.mesh.material = make_indicator_material(true)
			link_obj_1.add_child(l1_indicator)
			link_obj_2.add_child(l2_indicator)
			
			link = LinkHandling.link_objs[link_type].instantiate()
			link_obj_1.add_link(link)
			link_obj_2.add_link(link)
			link.initialize(link_obj_1, link_obj_2)
			add_child(link)

func make_indicator_material(emission=false) -> StandardMaterial3D:
	var material = StandardMaterial3D.new()
	material.albedo_color = LinkHandling.link_colors[link_type]
	if emission:
		material.emission_enabled = true
		material.emission = material.albedo_color
	return material

func _on_started_looking_at_item(body: PhysicsBody3D):
	obj_to_link = body

func _on_stopped_looking_at_item(_body):
	obj_to_link = null
