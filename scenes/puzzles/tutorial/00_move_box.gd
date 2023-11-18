extends Node3D

@onready var tutorials = [
    $Tutorial/Tutorial01,
    $Tutorial/Tutorial02
]

var current_tutorial = 0

func set_tutorial(t: int):
    tutorials[current_tutorial].hide()
    current_tutorial = t
    tutorials[current_tutorial].show()

# Called when the node enters the scene tree for the first time.
func _ready():
    for t in tutorials:
        t.hide()
    tutorials[0].show()

func _on_pause_menu_game_paused():
    tutorials[current_tutorial].hide()

func _on_pause_menu_game_unpaused():
    tutorials[current_tutorial].show()


func _on_win_area_1_win_area_entered():
    set_tutorial(1)
