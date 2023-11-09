extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true

func _on_resume_button_pressed():
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func _on_quit_to_menu_button_pressed():
	save_game()
	get_tree().paused = false
	Transition.change_scene("res://scenes/UI/main_menu.tscn")

func _on_reset_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	Transition.reload_scene()
	await Transition.transition_halfway
	hide()

func save_game():
	var filename = get_tree().current_scene.get_scene_file_path()
	var save = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save.store_string(filename)
	
