class_name PlayerState extends State

#var zone_name:String = "exteriors/EXT1/level_1"
var zone_name:String = "stations/STA1/level_0"
var position:Vector3 = Vector3.ZERO
var rotation:Vector3 = Vector3.ZERO
var current_item_type:Item.ItemType = -1
var current_item_key:String = ""

func _init():
	super("player")
