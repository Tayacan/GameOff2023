extends RayCast3D

signal started_looking_at_item(body: PhysicsBody3D)
signal stopped_looking_at_item(body: PhysicsBody3D)

var looking_at: PhysicsBody3D = null
var old_glow_material: StandardMaterial3D = null
var glow_material: StandardMaterial3D = preload("res://materials/glowing_panels/focus.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var obj = get_collider()
	if obj and obj.is_in_group("linkable"):
		if obj != looking_at:
			if looking_at != null:
				stopped_looking_at_item.emit(looking_at)
			looking_at = obj
			started_looking_at_item.emit(looking_at)
	else:
		if looking_at != null:
			stopped_looking_at_item.emit(looking_at)
			looking_at = null

func highlight(body):	
	old_glow_material = body.get_glow()
	body.set_glow(glow_material)

func remove_highlight(body):
	body.set_glow(old_glow_material)

func _on_started_looking_at_item(body):
	if body.has_method('set_glow'):
		highlight(body)

func _on_stopped_looking_at_item(body):
	if body.has_method('set_glow'):
		remove_highlight(body)
