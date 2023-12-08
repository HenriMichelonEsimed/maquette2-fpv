extends Dialog

@onready var button_yes = $Panel/Content/VBoxContainer/Bottom/ButtonYes
@onready var button_no = $Panel/Content/VBoxContainer/Bottom/ButtonNo
@onready var button_cancel = $Panel/Content/VBoxContainer/Top/ButtonCancel

var _on_confirm:Callable

func _unhandled_input(event):
	if (ignore_input()): return
	if (Input.is_action_just_pressed("cancel")):
		close()
	elif Input.is_action_just_pressed("accept") and not button_no.has_focus() and not button_cancel.has_focus():
		_on_button_yes_pressed()

func open(title:String, text:String, on_confirm):
	super._open()
	_on_confirm = on_confirm
	$Panel/Content/VBoxContainer/Top/Label.text = tr(title)
	$Panel/Content/VBoxContainer/Label.text = tr(text)
	button_yes.grab_focus()

func _on_button_yes_pressed():
	_on_confirm.call(true)
	close()

func _on_button_no_pressed():
	_on_confirm.call(false)
	close()

