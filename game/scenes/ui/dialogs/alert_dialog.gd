extends Dialog

@onready var button_ok = $Panel/Content/VBoxContainer/Bottom/ButtonOk

func _unhandled_input(event):
	if (ignore_input()): return
	if (Input.is_action_just_pressed("cancel") or Input.is_action_just_pressed("ui_accept")):
		close()
		
func open(title:String,message:String,free=true):
	super._open()
	$Panel/Content/VBoxContainer/Top/Label.text = tr(title)
	$Panel/Content/VBoxContainer/Label.text = tr(message)
	$Panel/Content/VBoxContainer/Bottom/ButtonCancel.grab_focus()
	Tools.set_shortcut_icon(button_ok, Tools.SHORTCUT_ACCEPT)
