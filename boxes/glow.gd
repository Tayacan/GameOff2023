extends Node3D

@onready var cube : MeshInstance3D = $Cube

func set_glow_focus(material: StandardMaterial3D):
    cube.set_surface_override_material(3, material)

func get_glow_focus():
    return cube.get_surface_override_material(3)

func set_glow_link(material: StandardMaterial3D):
    cube.set_surface_override_material(2, material)

func get_glow_link():
    return cube.get_surface_override_material(2)
