extends Node3D

var obj_to_link : PhysicsBody3D = null
var link_obj_1 : PhysicsBody3D = null
var indicator : PackedScene = null
var indicator_open : PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	indicator = preload("res://boxes/link_indicator.tscn")
	indicator_open = preload("res://boxes/link_indicator_open.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("link") and obj_to_link and obj_to_link.has_method("add_link"):
		print_debug("Clicked on: " + str(obj_to_link))
		if link_obj_1 == null:
			obj_to_link.add_child(indicator_open.instantiate())
			link_obj_1 = obj_to_link
		else:
			for child in link_obj_1.get_children():
				if child.name == "Indicator":
					child.queue_free()
			link_obj_1.add_child(indicator.instantiate())
			obj_to_link.add_child(indicator.instantiate())
			link_obj_1.add_link(obj_to_link)
			obj_to_link.add_link(link_obj_1)
			link_obj_1 = null

func _on_started_looking_at_item(body: PhysicsBody3D):
	obj_to_link = body

func _on_stopped_looking_at_item(body):
	obj_to_link = null
