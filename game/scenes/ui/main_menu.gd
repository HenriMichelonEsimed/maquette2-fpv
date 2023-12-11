extends Control

@onready var button_quit:Button = $Menu/ButtonQuit
@onready var button_continue:Button = $Menu/ButtonContinue
@onready var menu = $Menu
@onready var loading_screen = preload("res://scenes/loading_screen.tscn")

func _ready():
	GameState.game_started = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_shortcuts()
	GameState.prepare_game(false)
	Tools.preload_zone(GameState.player_state.zone_name)

func _on_resized():
	if (menu != null):
		var vsize = get_viewport().size / get_viewport().content_scale_factor
		menu.position.x = vsize.x - (vsize.x / 4) - menu.size.x
		menu.position.y = (vsize.y -  menu.size.y) / 2

func _input(event):
	if (Input.is_action_just_pressed("accept")):
		_on_button_continue_pressed()
	elif (Input.is_action_just_pressed("cancel")):
		_on_button_quit_pressed()

func set_shortcuts():
	Tools.set_shortcut_icon(button_quit, Tools.SHORTCUT_CANCEL)
	Tools.set_shortcut_icon(button_continue, Tools.SHORTCUT_ACCEPT)
	
func _on_button_settings_pressed():
	var dlg = Tools.load_dialog(self, Tools.DIALOG_SETTINGS)
	dlg.open()

func _on_button_quit_pressed():
	get_tree().quit()

func _on_button_continue_pressed():
	GameState.prepare_game(true)
	get_tree().change_scene_to_packed(loading_screen)

func _on_button_new_pressed():
	GameState.prepare_game(false)
	get_tree().change_scene_to_packed(loading_screen)

