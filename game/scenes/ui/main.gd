class_name MainUI extends Control

@export var player:Player

@onready var label_saving:Label = $LabelSaving
@onready var time_saving:Timer = $LabelSaving/Timer
@onready var label_info:Label = $HUD/LabelInfo
@onready var focused_button:Button = $Menu/MainMenu/ButtonInventory
@onready var label_notif:Label = $HUD/LabelNotification
@onready var timer_notif:Timer = $HUD/LabelNotification/Timer
@onready var menu = $Menu
@onready var hud = $HUD
@onready var blur = $Blur

var _displayed_node:Node
var _current_screen = null
var _restart_timer_notif:bool = false
var _talking:bool = false
var _trading:bool = false

func _ready():
	blur.visible = false
	label_saving.visible = false
	label_info.visible = false
	menu.visible = false
	label_notif.visible = false
	GameState.connect("saving_start", _on_saving_start)
	GameState.connect("saving_end", _on_saving_end)
	player.interactions.connect("display_info", _on_display_info)
	player.interactions.connect("hide_info", hide_info)

func _input(event):
	if (_current_screen != null):
		return
	if (label_info.visible):
		if (event is InputEventMouseMotion) or (Input.is_action_pressed("look_left") or (Input.is_action_pressed("look_right"))):
			_label_info_position()
			return
	if (Input.is_action_just_pressed("menu")):
		if (_current_screen != null):
			_current_screen = null
		if (menu.visible):
			menu_close()
		else:
			menu_open()
	elif (Input.is_action_just_pressed("cancel") and menu.visible):
		menu_close()
	elif (Input.is_action_just_pressed("quit")):
		_on_save_before_quit_confirm(true)
	elif Input.is_action_just_pressed("inventory"):
		inventory_open()
	elif  Input.is_action_just_pressed("terminal"):
		terminal_open()

func pause_game(blur_screen:bool=true):
	if (not timer_notif.is_stopped()):
		timer_notif.stop()
		_restart_timer_notif = true
	hud.visible = false
	if (blur_screen):
		blur.visible = true

func resume_game(_dummy=null):
	hud.visible = true
	blur.visible = false
	_current_screen = null
	if( _restart_timer_notif):
		timer_notif.start()
		_restart_timer_notif = false

func menu_open():
	GameState.pause_game()
	menu.visible = true
	focused_button.grab_focus()

func menu_close(_dummy=null):
	GameState.resume_game()
	menu.visible = false
	
func npc_talk(char:InteractiveCharacter, phrase:String, answers:Array):
	if (_trading):
		return
	if (not _talking):
		_current_screen = Tools.load_screen(self, Tools.SCREEN_NPC_TALK)
		_current_screen.open()
		_talking = true
	_current_screen.talk(char, phrase, answers)

func npc_end_talk():
	_current_screen.close()
	_talking = false

func npc_trade(char:InteractiveCharacter):
	_trading = true
	var trade_screen = Tools.load_screen(self, Tools.SCREEN_NPC_TRADE)
	trade_screen.open(char, npc_trade_end)
	_current_screen.release_focus()

func npc_trade_end():
	_trading = false	
	_current_screen.player_text_list.grab_focus()

func storage_open(node:Storage, on_storage_close:Callable):
	_current_screen = Tools.load_dialog(self, Tools.DIALOG_TRANSFERT_ITEMS, resume_game)
	_current_screen.open(node, on_storage_close)

func inventory_open():
	_current_screen = Tools.load_screen(self, Tools.SCREEN_INVENTORY, menu_close)
	_current_screen.open()
	
func terminal_open():
	_current_screen = Tools.load_screen(self, Tools.SCREEN_TERMINAL, menu_close)
	_current_screen.open()
	_on_timer_notif_timeout()

func load_savegame_open():
	_current_screen = Tools.load_dialog(self, Tools.DIALOG_LOAD_SAVEGAME, menu_close)
	_current_screen.open(_on_load_savegame)

func settings_open():
	_current_screen = Tools.load_dialog(self, Tools.DIALOG_SETTINGS, menu_close)
	_current_screen.open()

func savegame_open():
	_current_screen = Tools.load_dialog(self, Tools.DIALOG_INPUT, menu_close)
	_current_screen.open("Save game", StateSaver.get_last_savegame(), _on_savegame_input)

func display_keymaps():
	_current_screen = Tools.load_screen(self, Tools.SCREEN_CONTROLLER, menu_close)
	_current_screen.open()

func display_notification(message:String):
	timer_notif.stop()
	label_notif.text = message
	label_notif.visible = true
	timer_notif.start()

func _on_load_savegame(savegame:String):
	menu.visible = false
	GameState.load_game(savegame)
	get_tree().reload_current_scene()
	
func _on_savegame_input(savegame):
	if (savegame != null):
		if (StateSaver.savegame_exists(savegame)):
			GameState.savegame_name = savegame
			var dlg = Tools.load_dialog(self, Tools.DIALOG_CONFIRM, menu_close)
			dlg.open("Save game", "Overwrite existing save?", _on_savegame_confirm)
		else:
			GameState.save_game(savegame)

func _on_savegame_confirm(overwrite:bool):
	if (overwrite):
		GameState.save_game(GameState.savegame_name)
		menu_close()

func _on_saving_start():
	label_saving.visible = true

func _on_saving_end():
	time_saving.start()

func _on_saving_timer_timeout():
	label_saving.visible = false
	
func _label_info_position():
	var pos:Vector3 = _displayed_node.global_position
	pos.y = player.global_position.y + 1.5
	label_info.position = player.camera.unproject_position(pos)
	#label_info.position.y = (size.y - label_info.size.y)/2
	
func _on_display_info(node:Node3D):
	_displayed_node = node
	var label:String = tr(str(_displayed_node))
	if (label.is_empty()): return
	label_info.text = label
	_label_info_position()
	label_info.visible = true

func hide_info():
	label_info.visible = false
	label_info.text = ''

func _on_button_quit_pressed():
	_current_screen = Tools.load_dialog(self, Tools.DIALOG_CONFIRM, menu_close)
	_current_screen.open("Save ?", "Save game before exiting ?", _on_save_before_quit_confirm)

func _on_save_before_quit_confirm(save:bool):
	if (save): 
		GameState.save_game()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().quit()

func _on_timer_notif_timeout():
	label_notif.visible = false
