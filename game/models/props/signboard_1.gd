@tool
extends StaticBody3D

@export var texture:Texture2D

func _ready():
	if (texture != null):
		var mat = StandardMaterial3D.new()
		mat.albedo_texture = texture
		$Plane.set_surface_override_material(1, mat)

