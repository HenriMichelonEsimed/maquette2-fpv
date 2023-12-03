extends Object
class_name Tools

const DIALOG_SELECT_QANTITY = "select_quantity_dialog"
const DIALOG_TRANSFERT_ITEMS = "items_transfert_dialog"

static func load_dialog(parent:Node, dialog:String, on_close = null) -> Dialog:
	var scene = load("res://scenes/ui/dialogs/" + dialog + ".tscn").instantiate()
	parent.add_child(scene)
	if (on_close != null): 
		scene.connect("on_close", on_close)
	return scene

static func show_item(item:Item, node_3d:Node3D):
	for c in node_3d.get_children():
		c.queue_free()
	var clone = item.duplicate()
	node_3d.add_child(clone)
	clone.position = Vector3.ZERO
	clone.rotation = Vector3.ZERO
	clone.scale = clone.scale * clone.preview_scale * 1.2
