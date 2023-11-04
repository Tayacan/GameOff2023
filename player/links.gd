extends Node3D

var obj_to_link : PhysicsBody3D = null
var link_obj_1 : PhysicsBody3D = null
var link_obj_2 : PhysicsBody3D = null
var l1_indicator : Node3D = null
var l2_indicator : Node3D = null
var link : Node3D = null

var indicator : PackedScene = null
var indicator_open : PackedScene = null
var link_obj : PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	indicator = preload("res://links/link_indicator.tscn")
	indicator_open = preload("res://links/link_indicator_open.tscn")
	link_obj = preload("res://links/static_forward_link.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	handle_clear()
	handle_link()

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
	if Input.is_action_just_pressed("link") and obj_to_link and obj_to_link.has_method("add_link"):
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
			l1_indicator = indicator_open.instantiate()
			obj_to_link.add_child(l1_indicator)
			link_obj_1 = obj_to_link
		else:
			link_obj_2 = obj_to_link
			l1_indicator.queue_free()
			l1_indicator = indicator.instantiate()
			l2_indicator = indicator.instantiate()
			link_obj_1.add_child(l1_indicator)
			link_obj_2.add_child(l2_indicator)
			
			link = link_obj.instantiate()
			link_obj_1.add_link(link)
			link_obj_2.add_link(link)
			link.initialize(link_obj_1, link_obj_2)
			add_child(link)

func _on_started_looking_at_item(body: PhysicsBody3D):
	obj_to_link = body

func _on_stopped_looking_at_item(_body):
	obj_to_link = null
