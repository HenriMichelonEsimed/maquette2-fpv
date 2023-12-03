extends Control

@onready var label_saving:Label = $LabelSaving

func _ready():
	GameState.connect("saving_start", _on_saving_start)
	GameState.connect("saving_end", _on_saving_end)
	
func _on_saving_start():
	label_saving.visible = true

func _on_saving_end():
	label_saving.start()

func _on_saving_timer_timeout():
	label_saving.visible = false
