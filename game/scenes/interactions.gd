class_name Interactions extends Area3D

@export var player:Player

signal display_info(node:Node3D)
signal hide_info()
signal item_collected(item:Item, quantity:int)

var collect_items:Array[Node] = []
var item_to_collect:Item = null
var node_to_use:Usable = null
var char_to_talk:InteractiveCharacter = null

func _unhandled_input(event):
	if ((event is InputEventMouseButton) and (event.button_index == MOUSE_BUTTON_LEFT)) or ((event is InputEventJoypadButton) and (event.button_index == JOY_BUTTON_A)) or ((event is InputEventKey) and (event.physical_keycode == KEY_ENTER)):
		if (event.pressed):
			action_use()

func action_use():
	if (node_to_use != null):
		player.look_at_node(node_to_use)
		node_to_use.use(true)
	elif (item_to_collect != null):
		player.look_at_node(item_to_collect)
		item_collected.emit(item_to_collect, -1)
	elif (char_to_talk != null):
		player.look_at_node(char_to_talk)
		char_to_talk.interact()

func _on_collect_item_aera_body_entered(node:Node):
	collect_items.push_back(node)
	if item_to_collect == null:
		_collect()

func _collect():
	if (collect_items.is_empty()): return
	var node = collect_items.pop_back()
	if (node is Item):
		item_to_collect = node
		display_info.emit(node)
	elif (node is Usable):
		node_to_use = node
		display_info.emit(node)
	elif (node is Trigger):
		node.trigger()
	elif (node is InteractiveCharacter):
		char_to_talk = node
		display_info.emit(node)

func _on_collect_item_aera_body_exited(_node:Node):
	item_to_collect = null
	node_to_use = null
	char_to_talk = null
	hide_info.emit()
	_collect()
