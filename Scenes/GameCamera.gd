extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_limits(rect):
	# rect is in the form [leftmost_x, rightmost_x, smallest_y, largest_y]
	limit_left = rect[0]
	limit_right = rect[1]
	limit_top = rect[2]
	limit_bottom = rect[3]
	
