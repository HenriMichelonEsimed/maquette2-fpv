class_name Dialog extends Control

var _on_close = null
var _resume:bool = true

func _open():
	if (get_tree().paused):
		_resume = false
	else:
		process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close():
	if (_resume):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
	if (_on_close != null):
		_on_close.call(self)
	queue_free()
