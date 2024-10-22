extends Object
class_name Tools

const DIALOG_SELECT_QUANTITY = "select_quantity"
const DIALOG_TRANSFERT_ITEMS = "items_transfert"
const DIALOG_LOAD_SAVEGAME = "load_savegame"
const DIALOG_SETTINGS = "settings"
const DIALOG_INPUT = "input"
const DIALOG_CONFIRM = "confirm"
const DIALOG_ALERT = "alert"
const DIALOG_PLAYER_SETUP = "player_setup"

const SCREEN_INVENTORY = "inventory"
const SCREEN_TERMINAL = "terminal"
const SCREEN_CONTROLLER = "controller"
const SCREEN_GAMEOVER = "gameover"
const SCREEN_NPC_TALK = "talk"
const SCREEN_NPC_TRADE = "trade"

const CONTROLLER_KEYBOARD = "keyboard"
const CONTROLLER_XBOX = "xbox"
const CONTROLLER_PS = "ps"

const SHORTCUT_DROP = "drop"
const SHORTCUT_DELETE = "drop"
const SHORTCUT_CANCEL = "cancel"
const SHORTCUT_INVENTORY = "inventory"
const SHORTCUT_CRAFT = "craft"
const SHORTCUT_DECLINE = "decline"
const SHORTCUT_MENU = "menu"
const SHORTCUT_TERMINAL = "terminal"
const SHORTCUT_USE = "use"
const SHORTCUT_ALL = "all"
const SHORTCUT_ACCEPT = "accept"

const ITEMS_PATH = [ 'tools', 'consum', 'misc', 'quest']

static func load_shortcut_icon(name:String):
	var controller = CONTROLLER_KEYBOARD
	if GameState.use_joypad:
		controller = CONTROLLER_PS if GameState.use_joypad_ps else CONTROLLER_XBOX 
	return load("res://assets/textures/controllers/buttons/" + controller + "/" + name + ".png")

static func load_item(type:int,name:String):
	var item = load("res://models/items/" + ITEMS_PATH[type] + "/" + name + ".tscn")
	if (item != null):
		return item.instantiate()
	return null

static func load_char(_char:String):
	var item = load("res://models/chars/" + _char + "/" + _char + ".tscn")
	if (item != null):
		return item.instantiate()
	return null

static func load_zone(zone_name:String):
	var zone_path = "res://zones/" + zone_name + ".tscn"
	var _dummy = []
	if (ResourceLoader.load_threaded_get_status(zone_path, _dummy) == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE):
		ResourceLoader.load_threaded_request(zone_path, "", true)
	return ResourceLoader.load_threaded_get(zone_path)

static func preload_zone(zone_name:String):
	var zone_path = "res://zones/" + zone_name + ".tscn"
	return ResourceLoader.load_threaded_request(zone_path, "", true)

static func preload_zone_status(zone_name:String) -> ResourceLoader.ThreadLoadStatus:
	var zone_path = "res://zones/" + zone_name + ".tscn"
	return ResourceLoader.load_threaded_get_status(zone_path)

static func load_dialog(parent:Node, dialog:String, on_close = null) -> Dialog:
	var scene = load("res://scenes/ui/dialogs/" + dialog + "_dialog.tscn").instantiate()
	parent.add_child(scene)
	if (on_close != null): 
		scene._on_close = on_close
	return scene

static func load_screen(parent:Node, screen:String, on_close = null) -> Dialog:
	var scene = load("res://scenes/ui/" + screen + "_screen.tscn").instantiate()
	parent.add_child(scene)
	if (on_close != null): 
		scene._on_close = on_close
	return scene

static func load_controller_texture(controller:String) -> Texture2D:
	return load("res://assets/textures/controllers/" + controller + ".png")

static func show_item(item:Item, node_3d:Node3D):
	for c in node_3d.get_children():
		c.queue_free()
	var scale = item.preview_scale
	var clone = item.duplicate(0)
	node_3d.add_child(clone)
	clone.position = Vector3.ZERO
	clone.rotation = Vector3.ZERO
	clone.scale = clone.scale * scale * 1.2

static func show_character(_char:InteractiveCharacter, node_3d:Node3D):
	for c in node_3d.get_children():
		c.queue_free()
	var clone = _char.duplicate(0)
	node_3d.add_child(clone)
	clone.position = Vector3.ZERO
	clone.rotation = Vector3.ZERO
	clone.scale = Vector3(1.0, 1.0, 1.0)

static func set_shortcut_icon(button:Control, name:String):
	if (button is Button):
		button.icon = load_shortcut_icon(name)
	elif (button is TextureRect):
		button.texture = load_shortcut_icon(name)

static func reset_shortcut_icon(button:Control):
	if (button is Button):
		button.icon = null
	elif (button is TextureRect):
		button.texture = null
