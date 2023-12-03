class_name State extends Object

var name:String
var parent:Node

func _init(name:String, parent:Node=null):
	self.parent = parent
	self.name = name
