extends Node

@onready var background_music = $BackgroundMusic
@onready var loop_pause_timer = $LoopPauseTimer

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

func _on_audio_stream_player_finished():
    loop_pause_timer.start()

func _on_timer_timeout():
    background_music.play()
