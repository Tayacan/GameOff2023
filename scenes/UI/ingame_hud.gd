extends Control

@export var objective: String = ""

@onready var objective_label: Label = $ObjectiveLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	objective_label.text = objective
