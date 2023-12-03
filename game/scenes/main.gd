extends Node3D

@onready var player:Player = $Player

func _ready():
	if get_viewport().size.x > 1920:
		get_viewport().content_scale_factor = 2.2
	elif get_viewport().size.x >= 7680 :
		get_viewport().content_scale_factor = 3
	GameState.player = player
	var zone = $Level
	_change_zone(zone)

func _input(event):
	if (event is InputEventKey):
		if (event.physical_keycode == KEY_Z) and (Input.is_key_pressed(KEY_CTRL)):
			GameState.saveGame()
			_quit()

func _change_zone(zone:Zone):
	if (GameState.current_zone != null):
		for node:Node in GameState.current_zone.find_children("*", "Storage", true, true):
			node.disconnect("open", _on_storage_open)
	GameState.current_zone = zone
	for node:Node in GameState.current_zone.find_children("*", "Storage", true, true):
		node.connect("open", _on_storage_open)

func _on_storage_open(node:Storage):
	Tools.load_dialog(self, Tools.DIALOG_TRANSFERT_ITEMS).open(node, _on_storage_close)
	
func _on_storage_close(node:Storage):
	node.use()
	
func _quit():
	get_tree().quit()
