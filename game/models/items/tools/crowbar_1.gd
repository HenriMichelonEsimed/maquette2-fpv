extends ItemTool

func use():
	super.use()
	rotate_y(deg_to_rad(180))
	rotate_z(deg_to_rad(90))
