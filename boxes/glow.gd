extends Node3D

@onready var cube : MeshInstance3D = $Cube

func set_glow_material(material: StandardMaterial3D):
	cube.mesh.surface_set_material(2, material)

func get_glow_material():
	return cube.mesh.surface_get_material(2)
