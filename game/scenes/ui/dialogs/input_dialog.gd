extends Dialog

signal input(text)

var _on_savegame_input:Callable

func _unhandled_input(event):
	if (ignore_input()): return
	if Input.is_action_just_pressed("cancel"):
		close()
	elif Input.is_action_just_pressed("accept"):
		_on_button_ok_pressed()
		
func open(title:String, text:String, on_savegame_input):
	super._open()
	_on_savegame_input = on_savegame_input
	$Panel/Content/VBoxContainer/Top/Label.text = tr(title)
	$Panel/Content/VBoxContainer/Edit.text = tr(text)
	$Panel/Content/VBoxContainer/Edit.select_all()
	$Panel/Content/VBoxContainer/Edit.grab_focus()

func _on_button_ok_pressed():
	close()
	_on_savegame_input.call($Panel/Content/VBoxContainer/Edit.text)
