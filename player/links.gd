extends Node3D

var obj_to_link : PhysicsBody3D = null
var link_obj_1 : PhysicsBody3D = null
var link_obj_2 : PhysicsBody3D = null
var l1_indicator : Node3D = null
var l2_indicator : Node3D = null

var indicator : PackedScene = null
var indicator_open : PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	indicator = preload("res://boxes/link_indicator.tscn")
	indicator_open = preload("res://boxes/link_indicator_open.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("link") and obj_to_link and obj_to_link.has_method("add_link"):
		# Remove old link if there is one
		if link_obj_1 and link_obj_2:
			l1_indicator.queue_free()
			l2_indicator.queue_free()
			link_obj_1.remove_link()
			link_obj_2.remove_link()
			link_obj_1 = null
			link_obj_2 = null
		
		# Set up new link
		if not link_obj_1:
			l1_indicator = indicator_open.instantiate()
			obj_to_link.add_child(l1_indicator)
			link_obj_1 = obj_to_link
		else:
			l1_indicator.queue_free()
			l1_indicator = indicator.instantiate()
			l2_indicator = indicator.instantiate()
			link_obj_1.add_child(l1_indicator)
			obj_to_link.add_child(l2_indicator)
			link_obj_1.add_link(obj_to_link)
			link_obj_2 = obj_to_link

func _on_started_looking_at_item(body: PhysicsBody3D):
	obj_to_link = body

func _on_stopped_looking_at_item(_body):
	obj_to_link = null
