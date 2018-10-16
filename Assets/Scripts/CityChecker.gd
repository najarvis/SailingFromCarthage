extends Area2D

func _ready():
	connect("area_entered", self, "my_func")

func my_func(other_object):
	print(other_object)