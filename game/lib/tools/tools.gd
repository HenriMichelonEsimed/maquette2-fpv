extends Object
class_name Tools

const DIALOG_SELECT_QANTITY = "select_quantity"
const DIALOG_TRANSFERT_ITEMS = "items_transfert"
const DIALOG_LOAD_SAVEGAME = "load_savegame"
const DIALOG_SETTINGS = "settings"
const DIALOG_INPUT = "input"
const DIALOG_CONFIRM = "confirm"
const SCREEN_INVENTORY = "inventory"
const SCREEN_TERMINAL = "terminal"
const SCREEN_CONTROLLER = "controller"
const CONTROLLER_KEYBOARD = "keyboard"
const CONTROLLER_XBOX = "xbox"

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
