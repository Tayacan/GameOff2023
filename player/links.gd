extends Node3D

var obj_to_link : PhysicsBody3D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("link") and obj_to_link:
		print_debug("Clicked on: " + str(obj_to_link))

func _on_started_looking_at_item(body: PhysicsBody3D):
	obj_to_link = body


func _on_stopped_looking_at_item(body):
	obj_to_link = null
