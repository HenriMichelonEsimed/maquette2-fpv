extends Node3D

@onready var player:Player = $Player

func _ready():
	if get_viewport().size.x > 1920:
		get_viewport().content_scale_factor = 2.2
	elif get_viewport().size.x >= 7680 :
		get_viewport().content_scale_factor = 3
	GameState.player = player

func _input(event):
	if (event is InputEventKey):
		if (event.physical_keycode == KEY_Z) and (Input.is_key_pressed(KEY_CTRL)):
			GameState.saveGame()
			_quit()

func _quit():
	get_tree().quit()
	
