extends ItemConsumable

func use():
	super.use()
	rotate_z(deg_to_rad(-90))
