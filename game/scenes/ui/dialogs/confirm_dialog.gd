extends Dialog

var _on_confirm:Callable

func _unhandled_input(event):
	if (Input.is_action_just_pressed("cancel")):
		close()
	elif Input.is_action_just_pressed("player_use_nomouse"):
		_on_button_yes_pressed()

func open(title:String, text:String, on_confirm):
	super._open()
	_on_confirm = on_confirm
	$Panel/Content/VBoxContainer/Top/Label.text = tr(title)
	$Panel/Content/VBoxContainer/Label.text = tr(text)
	$Panel/Content/VBoxContainer/Bottom/ButtonYes.grab_focus()

func _on_button_yes_pressed():
	_on_confirm.call(true)
	close()

func _on_button_no_pressed():
	_on_confirm.call(false)
	close()

