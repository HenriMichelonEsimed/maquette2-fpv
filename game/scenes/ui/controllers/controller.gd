extends Dialog

func open():
	super._open()
	var ratio = size.x / size.y
	var vsize = get_viewport().size / get_viewport().content_scale_factor
	size.x = vsize.x / 1.2
	size.y = size.x / ratio
	position.x = (vsize.x - size.x) / 2
	position.y = (vsize.y - size.y) / 2
	
func _input(event):
	if Input.is_anything_pressed():
		close()
