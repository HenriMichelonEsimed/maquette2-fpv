class_name Interactions extends RayCast3D

@export var camera:Node3D

signal display_info(node:Node3D)
signal hide_info()
signal item_collected(item:Item, quantity:int)

var target_node:Node3D = null

func _unhandled_input(event):
	if (event is InputEventMouseMotion):
		_next_body()
	elif ((event is InputEventMouseButton) and (event.button_index == MOUSE_BUTTON_LEFT)):
		if (event.pressed):
			action_use()

func _input(event):
	if ((event is InputEventJoypadButton) and (event.button_index == JOY_BUTTON_A)) or ((event is InputEventKey) and (event.physical_keycode == KEY_ENTER)):
		if (not event.pressed):
			action_use()
			
func _next_body():
	target_position.z = -(1 + exp(-camera.rotation.x*2) / 7)
	#print(target_position.z)
	force_raycast_update()
	if (is_colliding()):
		_on_collect_item_aera_body_entered(get_collider())
	else:
		_on_collect_item_aera_body_exited()
		
func _process(delta):
	_next_body()

func action_use():
	if (target_node == null): return
	if (target_node is Item):
		item_collected.emit(target_node, -1)
		_next_body()
	elif (target_node is Usable):
		target_node.use(true)
	elif (target_node is InteractiveCharacter):
		target_node.interact()
		target_node = null

func _on_collect_item_aera_body_entered(node:Node):
	if (node is Item):
		target_node = node
		display_info.emit(target_node)
	elif (node is Usable):
		target_node = node
		display_info.emit(target_node)
	elif (node is Trigger):
		node.trigger()
	elif (node is InteractiveCharacter):
		target_node = node
		display_info.emit(target_node)

func _on_collect_item_aera_body_exited():
	target_node = null
	hide_info.emit()

