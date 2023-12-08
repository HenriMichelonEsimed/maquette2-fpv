extends Dialog

func _unhandled_input(event):
	if (ignore_input()): return
	if (Input.is_action_just_pressed("cancel") or Input.is_action_just_pressed("ui_accept")):
		close()
		
func open(title:String,message:String,free=true):
	super._open()
	$Panel/Content/VBoxContainer/Top/Label.text = tr(title)
	$Panel/Content/VBoxContainer/Label.text = tr(message)
	$Panel/Content/VBoxContainer/Bottom/ButtonCancel.grab_focus()
