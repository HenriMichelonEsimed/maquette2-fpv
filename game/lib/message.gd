class_name Message extends Node

var subject:String
var from:String
var message:String
var key:String
var read:bool = false

func _init(_f, _s, _m, _k):
	from = _f
	subject = _s
	message = _m
	key = _k
