@tool
extends Node3D

@export var color:Color = Color(Color.WHITE)
@onready var neon:CSGBox3D = $Support/Neon/Light

func _ready():
	set_color(color)

func set_color(new_color:Color):
	var mat =  StandardMaterial3D.new()
	mat.albedo_color = new_color
	mat.shading_mode = 0
	for light in neon.find_children("*", "OmniLight3D", true):
		light.light_color = new_color
		neon.material = mat
