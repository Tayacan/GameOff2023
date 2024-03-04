extends Control

@export var controls_kb: Control
@export var controls_x_box: Control

@onready var all_controls: Array[Control] = [controls_kb, controls_x_box]

# Called when the node enters the scene tree for the first time.
func _ready():
    for c in all_controls:
        c.hide()
    controls_kb.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
    for c in all_controls:
        c.hide()
    if InputDevice.device == InputDevice.Device.KEYBOARD:
        controls_kb.show()
    else:
        controls_x_box.show()
