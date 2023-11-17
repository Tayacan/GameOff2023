extends Node3D

@onready var cube : MeshInstance3D = $Cube

func set_glow_material(material: StandardMaterial3D):
    cube.set_surface_override_material(2, material)

func get_glow_material():
    return cube.get_surface_override_material(2)
