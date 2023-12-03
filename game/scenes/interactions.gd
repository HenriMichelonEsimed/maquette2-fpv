extends Area3D

signal display_info(node:Node3D)
signal hide_info()
signal item_collected(item:Item, quantity:int)

var collect_items:Array[Item] = []
var item_to_collect:Item = null
var node_to_use:Usable = null
var char_to_talk:InteractiveCharacter = null

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
