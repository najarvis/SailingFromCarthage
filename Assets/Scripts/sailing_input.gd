extends "ship_class.gd"

var s
var in_city = false
var coin
var health

export var initial_pos = Vector2(0, 0)

var cell_size = 32

var resources = {}

func _ready():
	self.s = Ship.new(initial_pos * cell_size)
	position += self.s.pos
	self.health = 1
	
	self.coin = 100
	self.set_meta("player", true)
	
func _process(delta):
	var acc = 0
	if Input.is_action_pressed("ui_up"):
		acc += 1
	if Input.is_action_pressed("ui_down"):
		acc -= 1
		
	self.s.handle_acceleration(acc, delta)
	
	var turn_speed = 3.0
	if Input.is_action_pressed("ui_left"):
		self.s.turn(-turn_speed, delta)
	if Input.is_action_pressed("ui_right"):
		self.s.turn(turn_speed, delta)
	
	# self.s.update(delta)
	
	#position = self.s.pos
	move_and_slide(self.s.get_attempted_movement())
	rotation = self.s.orientation
	
	if get_node("../TileMap").get_player_tile(position) == 16 and not in_city:
		# IN CITY
		in_city = true
		get_node("..").go_to_city(position)
	
	if get_node("../TileMap").get_player_tile(position) != 16 and in_city:
		# IN CITY
		in_city = false
	
func buy_resource(resource, cost):
	if not self.resources.has(resource):
		self.resources[resource] = 1
	else:
		self.resources[resource] += 1
		
	self.coin -= cost
	
func sell_resource(resource, cost):
	self.resources[resource] -= 1
	self.coin += cost
	
func damage():
	self.health -= 1
	if self.health <= 0:
		# Dead
		get_tree().change_scene("res://Scenes/Sailing.tscn")