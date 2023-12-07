extends Object
class_name Tools

const DIALOG_SELECT_QANTITY = "select_quantity"
const DIALOG_TRANSFERT_ITEMS = "items_transfert"
const DIALOG_LOAD_SAVEGAME = "load_savegame"
const DIALOG_SETTINGS = "settings"
const DIALOG_INPUT = "input"
const DIALOG_CONFIRM = "confirm"
const DIALOG_ALERT = "alert"
const SCREEN_INVENTORY = "inventory"
const SCREEN_TERMINAL = "terminal"
const SCREEN_CONTROLLER = "controller"
const SCREEN_NPC_TALK = "talk"
const SCREEN_NPC_TRADE = "trade"
const CONTROLLER_KEYBOARD = "keyboard"
const CONTROLLER_XBOX = "xbox"
const ITEMS_PATH = [ 'tools', 'consum', 'misc', 'quest']

static func load_item(type:int,name:String):
	var item = load("res://models/items/" + ITEMS_PATH[type] + "/" + name + ".tscn")
	if (item != null):
		return item.instantiate()
	return null
	
static func load_zone(zone_name:String):
	var zone_path = "res://zones/" + zone_name + ".tscn"
	var _dummy = []
	if (ResourceLoader.load_threaded_get_status(zone_path, _dummy) == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE):
		ResourceLoader.load_threaded_request(zone_path)
	return ResourceLoader.load_threaded_get(zone_path)

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
	var clone = item.duplicate()
	node_3d.add_child(clone)
	clone.position = Vector3.ZERO
	clone.rotation = Vector3.ZERO
	clone.scale = clone.scale * clone.preview_scale * 1.2
