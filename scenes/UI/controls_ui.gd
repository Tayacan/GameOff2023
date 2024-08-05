extends Control

@export var controls_kb: Control
@export var controls_x_box: Control

@onready var all_controls: Array[Control] = [controls_kb, controls_x_box]

# Called when the node enters the scene tree for the first time.
func _ready():
    _switch_ui(InputDevice.device)
    InputDevice.input_device_changed.connect(_switch_ui)

func _switch_ui(device : InputDevice.Device):
    for c in all_controls:
        c.hide()
    match device:
        InputDevice.Device.KEYBOARD:
            controls_kb.show()
        InputDevice.Device.XBOX:
            controls_x_box.show()
            
