class_name Item extends StaticBody3D

enum ItemType {
	ITEM_UNKNOWN		= -1,
	ITEM_TOOLS			= 0,
	ITEM_CONSUMABLES	= 1,
	ITEM_MISCELLANEOUS	= 2,
	ITEM_QUEST			= 3
}

@export var key:String
@export var label:String
@export var price:float = 0.0
@export var type:ItemType
@export var preview_scale:float = 1.0
var original_rotation:Vector3

func _ready():
	label = tr(label)
	set_collision_layer_value(Consts.LAYER_WORLD, false)
	original_rotation = rotation
	enable()

func use():
	disable()
	position = Vector3.ZERO
	rotate_y(deg_to_rad(180))

func unuse():
	position = Vector3.ZERO
	rotation = Vector3.ZERO
	enable()

func collect():
	return true

func disable():
	set_collision_layer_value(Consts.LAYER_ITEM, false)
	
func enable():
	rotation = original_rotation
	set_collision_layer_value(Consts.LAYER_ITEM, true)
	
func _to_string():
	return label

