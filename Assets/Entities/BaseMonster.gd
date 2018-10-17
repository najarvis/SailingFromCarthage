extends KinematicBody2D

var t
var max_time
var vel = Vector2(0, 0)
var speed = 30

func _ready():
	max_time = 2
	t = max_time

func _process(delta):
	randomize()
	if t >= max_time:
		t = 0
		var new_dir = Vector2(randi() % 3 - 1, randi() % 3 - 1)
		vel = new_dir.normalized() * speed

	t += delta
	move_and_slide(vel)

func on_overlap(area):
	var player = area.get_node("..")
	if player.has_meta("player"):
		player.damage()
