extends Node

signal input_device_changed(new_device : Device)

enum Device { KEYBOARD, XBOX, PS }

var device = Device.KEYBOARD

func _input(event):
    if event is InputEventMouse or event is InputEventKey:
        if device != Device.KEYBOARD:
            input_device_changed.emit(Device.KEYBOARD)
        device = Device.KEYBOARD
    elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
        if device != Device.XBOX:
            input_device_changed.emit(Device.XBOX)
        device = Device.XBOX
