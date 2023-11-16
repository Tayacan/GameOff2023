extends Node

@onready var animation_player = $AnimationPlayer

signal transition_halfway

func change_scene(target : String):
    animation_player.play("dissolve")
    await animation_player.animation_finished
    transition_halfway.emit()
    get_tree().change_scene_to_file(target)
    animation_player.play_backwards("dissolve")

func reload_scene():
    animation_player.play("dissolve")
    await animation_player.animation_finished
    transition_halfway.emit()
    get_tree().reload_current_scene()
    animation_player.play_backwards("dissolve")
