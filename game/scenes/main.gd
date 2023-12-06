extends Node3D

@onready var player:Player = $Player

func _ready():
	GameState.player = player
	GameState.ui = $MainUI
	if get_viewport().size.x > 1920:
		get_viewport().content_scale_factor = 2.2
	elif get_viewport().size.x >= 7680 :
		get_viewport().content_scale_factor = 3
	var zone = $Level
	if not GameState.settings.keyboard_controller_shown:
		GameState.ui.display_keymaps()
		GameState.settings.keyboard_controller_shown = true
		GameState.save_game()
	_change_zone(zone)
	GameState.ui.inventory_open()

func _change_zone(zone:Zone):
	if (GameState.current_zone != null):
		for node:Node in GameState.current_zone.find_children("*", "Storage", true, true):
			node.disconnect("open", _on_storage_open)
	GameState.current_zone = zone
	for node:Node in GameState.current_zone.find_children("*", "Storage", true, true):
		node.connect("open", _on_storage_open)
	GameState.current_zone.visible = true

func _on_storage_open(node:Storage):
	GameState.ui.storage_open(node, _on_storage_close)
	
func _on_storage_close(node:Storage):
	node.use()
	
func _quit():
	get_tree().quit()
