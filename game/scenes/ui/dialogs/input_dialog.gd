extends Dialog

signal input(text)

var _on_savegame_input:Callable

func _input(event):
	if Input.is_action_just_pressed("cancel"):
		close()
	elif Input.is_action_just_pressed("player_use_nomouse"):
		_on_button_ok_pressed()
		
func open(title:String, text:String, on_savegame_input):
	super._open()
	_on_savegame_input = on_savegame_input
	$Panel/Content/VBoxContainer/Edit.grab_focus()
	$Panel/Content/VBoxContainer/Top/Label.text = tr(title)
	$Panel/Content/VBoxContainer/Edit.text = tr(text)
	$Panel/Content/VBoxContainer/Edit.select_all()
	$Panel/Content/VBoxContainer/Bottom/ButtonOk.grab_focus()

func _on_button_ok_pressed():
	close()
	_on_savegame_input.call($Panel/Content/VBoxContainer/Edit.text)
