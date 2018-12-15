extends KinematicBody2D

var t
var max_time
var vel = Vector2(0, 0)
var speed = 25
var health = 100.0
var angry_timer = 0.0
var happy_timer = 0.0

func _ready():
	max_time = 2
	t = max_time

func _process(delta):
	randomize()
	var player = $"..".get_player()
	if player.position.distance_to(position) < 200:
		var new_dir = (player.position - position).normalized()
		vel = new_dir * speed
	else:
		if t >= max_time:
			t = 0
			var new_dir = Vector2(randi() % 3 - 1, randi() % 3 - 1)
			vel = new_dir.normalized() * speed
	move_and_slide(vel)

	t += delta
	
	if angry_timer > 0:
		$AnimatedSprite.animation = "Anger"
		$AnimatedSprite.modulate = Color(.94, .5, .5)
		angry_timer -= delta
	elif happy_timer > 0:
		happy_timer -= delta
		$AnimatedSprite.animation = "Happy"
		$AnimatedSprite.modulate = Color.cornsilk
	else:
		$AnimatedSprite.animation = "Idle"
		$AnimatedSprite.modulate = Color(1.0, 1.0, 1.0)

func on_overlap(area):
	var other = area.get_node("..")
	if other.has_meta("player"):
		other.damage()
	if other.has_meta("npc"):
		other.destroy()
		if other.type == "warrior":
			self.health -= 10
			self.angry_timer = 1.0
			if self.health <= 0:
				queue_free()
		else:
			self.happy_timer = 1.0