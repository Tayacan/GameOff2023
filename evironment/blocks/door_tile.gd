extends Node3D

@onready var animation_player = $AnimationPlayer

func open_door():
    animation_player.play("Open")

func close_door():
    animation_player.play_backwards("Open")
