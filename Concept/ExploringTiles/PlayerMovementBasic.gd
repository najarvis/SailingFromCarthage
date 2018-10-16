extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var _base_speed = 100

func _ready():
	pass

func _process(delta):
	var vel = Vector2()
	if Input.is_action_pressed("ui_up"):
		vel.y -= 1	
	if Input.is_action_pressed("ui_down"):
		vel.y += 1	
	if Input.is_action_pressed("ui_left"):
		vel.x -= 1	
	if Input.is_action_pressed("ui_right"):
		vel.x += 1
		
	position += vel * delta * _base_speed