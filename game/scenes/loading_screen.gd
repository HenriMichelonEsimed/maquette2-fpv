extends Control

@onready var progress_bar:ProgressBar = $TextureRect/ProgressBar

var progress : Array[float]

func _ready():
	Tools.preload_zone(GameState.player_state.zone_name)

func _process(delta):
	var status =  Tools.preload_zone_status(GameState.player_state.zone_name, progress)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100 
		ResourceLoader.THREAD_LOAD_LOADED:
			get_tree().change_scene_to_file("res://scenes/main.tscn")
		ResourceLoader.THREAD_LOAD_FAILED:
			get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
