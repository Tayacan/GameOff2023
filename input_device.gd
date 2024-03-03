extends Node

enum Device { KEYBOARD, XBOX, PS }

var device = Device.KEYBOARD

func _input(event):
    if event is InputEventMouse or event is InputEventKey:
        device = Device.KEYBOARD
    elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
        device = Device.XBOX
