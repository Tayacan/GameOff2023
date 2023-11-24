extends Node3D

@export_file("*.tscn") var next_level : String

@onready var tutorials = [
    $Tutorial/Tutorial01,
    $Tutorial/Tutorial02
]

var current_tutorial = 0

func set_tutorial(t: int):
    tutorials[current_tutorial].hide()
    current_tutorial = t
    tutorials[current_tutorial].show()
    
func _ready():
    for t in tutorials:
        t.hide()
    tutorials[0].show()

func _on_pause_menu_game_paused():
    tutorials[current_tutorial].hide()

func _on_pause_menu_game_unpaused():
    tutorials[current_tutorial].show()


func _on_win_area_2_win_area_entered():
    Transition.change_scene(next_level)


func _on_win_area_win_area_entered():
    set_tutorial(1)


func _on_area_3d_body_entered(_body):
    tutorials[current_tutorial].hide()
