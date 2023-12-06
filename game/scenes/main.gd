extends Node3D

@onready var player:Player = $Player

var _previous_zone:Zone
var _last_spawnpoint:String

func _ready():
	GameState.player = player
	GameState.ui = $MainUI
	if get_viewport().size.x > 1920:
		get_viewport().content_scale_factor = 2.2
	elif get_viewport().size.x >= 7680 :
		get_viewport().content_scale_factor = 3
	_change_zone(GameState.player_state.zone_name, "default")
	if (GameState.player_state.position != Vector3.ZERO):
		player.move(GameState.player_state.position, GameState.player_state.rotation)
	if not GameState.settings.keyboard_controller_shown:
		GameState.ui.display_keymaps()
		GameState.settings.keyboard_controller_shown = true
		GameState.save_game()

func _change_zone(zone_name:String, spawnpoint_key:String):
	var new_zone:Zone
	if (_previous_zone != null) and (_previous_zone.zone_name == zone_name):
		new_zone = _previous_zone
	else:
		if (_previous_zone != null): 
			_previous_zone.queue_free()
		new_zone = Tools.load_zone(zone_name).instantiate()
	if (GameState.current_zone != null): 
		GameState.player.disconnect("item_collected", GameState.current_zone.on_item_collected)
		GameState.current_zone.disconnect("change_zone", _on_change_zone)
		for node in GameState.current_zone.find_children("*", "Storage", true, true):
			node.disconnect("open", _on_storage_open)
		#for node in GameState.current_zone.find_children("*", "Usable", true, true):
		#	node.disconnect("unlock", _on_usable_unlock)
		#for node in GameState.current_zone.find_children("*", "InteractiveCharacter", true, true):
		#	node.disconnect("talk", _on_npc_talk)
		#	node.disconnect("end_talk", _on_end_talk)
		remove_child(GameState.current_zone)
	_previous_zone = GameState.current_zone
	GameState.current_zone = new_zone
	GameState.player_state.zone_name = zone_name
	GameState.current_zone.connect("change_zone", _on_change_zone)
	GameState.player.connect("item_collected", GameState.current_zone.on_item_collected)
	add_child(GameState.current_zone)
	_spawn_player(spawnpoint_key)
	for node in GameState.current_zone.find_children("*", "Storage", true, true):
		node.connect("open", _on_storage_open)
	#for node in GameState.current_zone.find_children("*", "Usable", true, true):
	#	node.connect("unlock", _on_usable_unlock)
	#for node in GameState.current_zone.find_children("*", "InteractiveCharacter", true, true):
	#	node.connect("trade", _on_npc_trade)
	#	node.connect("talk", _on_npc_talk)
	#	node.connect("end_talk", _on_end_talk)
	GameState.current_zone.visible = true
	
func _spawn_player(spawnpoint_key:String):
	for node in GameState.current_zone.find_children("*", "SpawnPoint", false, true):
		if (node.key == spawnpoint_key):
			player.move(node.global_position, node.global_rotation)
			node.spawn()
			break
	_last_spawnpoint = spawnpoint_key
	
func _on_change_zone(trigger:ZoneChangeTrigger):
	if (trigger.zone_name == GameState.location.zone_name): 
		return
	_change_zone(trigger.zone_name, trigger.spawnpoint_key)
	trigger.is_triggered = false

func _on_storage_open(node:Storage):
	GameState.ui.storage_open(node, _on_storage_close)
	
func _on_storage_close(node:Storage):
	node.use()
	
func _quit():
	get_tree().quit()
