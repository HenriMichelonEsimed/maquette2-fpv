class_name Dialog extends Control

var _on_close = null

func _open(on_close=null):
	_on_close = on_close
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().paused = false
	if (_on_close != null):
		_on_close.call(self)
	visible = false
