extends Zone

func _ready():
	var env = load("res://scenes/environment/exterior.tscn").instantiate()
	env.day_time = 16
	add_child(env)
