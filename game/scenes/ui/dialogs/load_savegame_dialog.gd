extends Dialog

@onready var listSaves = $Panel/Content/VBoxContainer/ListSavegames

var saves = {}
var savegame = null
var _on_load_savegame:Callable

func open(on_load_savegame):
	_on_load_savegame = on_load_savegame
	super._open()
	_refresh()
	
func _refresh():
	listSaves.clear()
	for dir in StateSaver.get_savegames():
		listSaves.add_item(tr("[Auto save]") if dir==StateSaver.autosave_path else dir)
		listSaves.set_item_metadata(listSaves.item_count-1, dir)
	listSaves.grab_focus()
	if (listSaves.item_count > 0):
		listSaves.select(0)
		_on_list_savegames_item_selected(0)

func _unhandled_input(event):
	if (ignore_input()): return
	if (Input.is_action_just_pressed("cancel")):
		close()
	elif (Input.is_action_just_pressed("accept") and listSaves.has_focus()):
		_on_button_load_pressed()
	elif (Input.is_action_just_pressed("delete") and listSaves.has_focus()):
		_on_button_delete_pressed()

func _on_list_savegames_item_selected(index):
	savegame = listSaves.get_item_metadata(index)

func _on_button_load_pressed():
	if (savegame != null): 
		close()
		_on_load_savegame.call(savegame)

func _on_button_delete_pressed():
	if (savegame != null): 
		var delete_confirm_dlg = Tools.load_dialog(self, Tools.DIALOG_CONFIRM, _on_confirm_close)
		delete_confirm_dlg.open("Delete ?", tr("Delete saved game ' %s' ?") % savegame, _on_confirm_delete)
		
func _on_confirm_close():
	listSaves.grab_focus()
	
func _on_confirm_delete(confirm:bool):
	if confirm:
		StateSaver.delete(savegame)
		_refresh()
	else:
		_on_confirm_close()
