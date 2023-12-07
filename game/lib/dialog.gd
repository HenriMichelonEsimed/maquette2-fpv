class_name Dialog extends Control

var _on_close = null
var _resume:bool = true

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _open(blur_screen:bool=true):
	if (get_tree().paused):
		_resume = false
	else:
		GameState.pause_game(blur_screen)

func close():
	if (_resume):
		GameState.resume_game()
	if (_on_close != null):
		_on_close.call()
	queue_free()
