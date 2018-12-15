extends PathFollow2D

var t
var speed = 50.0
var rev
var end_t

func _ready():
	randomize()
	rev = randi()%2 == 0
	t = rand_range(0, 20) * speed
	end_t = t + speed * 60.0
	
func _process(delta):
	t += delta * (speed + (rand_range(0, 10) / 10.0))
	set_offset(t)
	if t > end_t:
		print("Removed")
		get_parent().remove_child(self)
	
func set_t(new_t):
	t = new_t
