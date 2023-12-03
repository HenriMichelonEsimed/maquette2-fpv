extends Control

@export var player:Player

@onready var label_saving:Label = $LabelSaving
@onready var time_saving:Timer = $LabelSaving/Timer
@onready var label_info:Label = $LabelInfo

var _displayed_node:Node

func _ready():
	label_saving.visible = false
	label_info.visible = false
	GameState.connect("saving_start", _on_saving_start)
	GameState.connect("saving_end", _on_saving_end)
	player.interactions.connect("display_info", _on_display_info)
	player.interactions.connect("hide_info", _on_hide_info)
	
func _input(event):
	if (event is InputEventMouseMotion) and (label_info.visible):
		_label_info_position()
	
func _on_saving_start():
	label_saving.visible = true

func _on_saving_end():
	time_saving.start()

func _on_saving_timer_timeout():
	label_saving.visible = false
	
func _label_info_position():
	var pos:Vector3 = _displayed_node.global_position
	pos.y = player.global_position.y + 2.0
	label_info.position = player.camera.unproject_position(pos)
	
func _on_display_info(node:Node3D):
	_displayed_node = node
	var label:String = tr(str(_displayed_node))
	if (label.is_empty()): return
	_label_info_position()
	label_info.text = label
	label_info.visible = true

func _on_hide_info():
	label_info.visible = false
	label_info.text = ''
