extends RayCast3D

signal started_looking_at_item(body: PhysicsBody3D)
signal stopped_looking_at_item(body: PhysicsBody3D)

var looking_at: PhysicsBody3D = null

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

func highlight(body: GeometryInstance3D):
	var material : Material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(1, 1, 1, 0.2)
	material.emission_enabled = true
	material.emission = Color(0.2, 0.2, 0.8)
	
	body.material_overlay = material

func remove_highlight(body: GeometryInstance3D):
	body.material_overlay = null


func _on_started_looking_at_item(body):
	for child in body.get_children():
		if child is GeometryInstance3D:
			highlight(child)


func _on_stopped_looking_at_item(body):
	for child in body.get_children():
		if child is GeometryInstance3D:
			remove_highlight(child)
