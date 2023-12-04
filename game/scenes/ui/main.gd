extends Control

@export var player:Player

@onready var label_saving:Label = $HUD/LabelSaving
@onready var time_saving:Timer = $HUD/LabelSaving/Timer
@onready var label_info:Label = $HUD/LabelInfo
@onready var menu = $Menu
@onready var hud = $HUD

var _displayed_node:Node
var _current_screen = null

func _ready():
	label_saving.visible = false
	label_info.visible = false
	menu.visible = false
	GameState.connect("saving_start", _on_saving_start)
	GameState.connect("saving_end", _on_saving_end)
	player.interactions.connect("display_info", _on_display_info)
	player.interactions.connect("hide_info", _on_hide_info)

func _input(event):
	if (Input.is_action_just_pressed("cancel")):
		if (_current_screen != null):
			_current_screen = null
		if (menu.visible):
			menu_close()
		else:
			menu_open()
	if (label_info.visible):
		if (event is InputEventMouseMotion) or (Input.is_action_pressed("look_left") or (Input.is_action_pressed("look_right"))):
			_label_info_position()

func menu_open():
	get_tree().paused = true
	menu.visible = true
	hud.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func menu_close(_dummy=null):
	get_tree().paused = false
	menu.visible = false
	hud.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func inventory_open():
	_current_screen = Tools.load_screen(self, Tools.SCREEN_INVENTORY, menu_close)
	_current_screen.open()

func _on_saving_start():
	label_saving.visible = true

func _on_saving_end():
	time_saving.start()

func _on_saving_timer_timeout():
	label_saving.visible = false
	
func _label_info_position():
	var pos:Vector3 = _displayed_node.global_position
	#pos.y = player.global_position.y + 1.5
	label_info.position = player.camera.unproject_position(pos)
	label_info.position.y = (size.y - label_info.size.y)/2
	
func _on_display_info(node:Node3D):
	_displayed_node = node
	var label:String = tr(str(_displayed_node))
	if (label.is_empty()): return
	label_info.text = label
	_label_info_position()
	label_info.visible = true

func _on_hide_info():
	label_info.visible = false
	label_info.text = ''

func _on_button_quit_pressed():
	get_tree().quit()
