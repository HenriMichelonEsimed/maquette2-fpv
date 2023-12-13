class_name MoveableProp extends RigidBody3D

@export var sound:AudioStream
@onready var audio:AudioStreamPlayer3D = AudioStreamPlayer3D.new()

func _ready():
	set_collision_layer_value(Consts.LAYER_WORLD, false)
	set_collision_layer_value(Consts.LAYER_MOVEABLE_PROP, true)
	set_collision_mask_value(Consts.LAYER_WORLD, true)
	set_collision_mask_value(Consts.LAYER_MOVEABLE_PROP, true)
	set_collision_mask_value(Consts.LAYER_PLAYER, true)
	connect("sleeping_state_changed", _on_sleeping_state_changed)
	audio.stream = sound
	audio.max_distance = 8
	audio.bus = "Effects"
	audio.volume_db = 35
	add_child(audio)

func _on_sleeping_state_changed():
	if (sleeping):
		audio.stop()
	else:
		audio.play()
