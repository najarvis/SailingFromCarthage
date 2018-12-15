extends Node2D

var orientation = 0.0
var pos
var sailing_speed
var target
var acc_fac = 0.9
var turn_rate

var _max_speed = 60.0
var _max_reverse_speed = -30.0

var path
var city
var world
var dest_city
var resource
var buy
var type

func _ready():
	self.set_meta("npc", true)

func init(pos, path, city, type, dest_city, resource=null, buy=null):
	self.pos = pos
	self.path = path
	self.city = city
	self.dest_city = dest_city
	self.resource = resource
	self.buy = buy
	self.world = city.world
	# self.gold = 0
	self.type = type
	self.sailing_speed = 0.0

	self.target = null
	position = self.pos
	
	if self.type == "warrior":
		self.modulate = Color.azure
		self.scale = Vector2(2.0, 2.0)

func _process(delta):
	if self.path != null:
		var next_pos = self.world.find_node("TileMap").map_to_world(self.path[0]) + ($"../TileMap".cell_size / 2)
		
		var move_dir = (next_pos - self.position).normalized()
		self.position += move_dir * delta * 100
		var goal_orientation = atan2(move_dir.x, -move_dir.y) - PI / 2
		if goal_orientation != self.orientation:
			var turn_direction = (goal_orientation - self.orientation) / abs(goal_orientation - self.orientation)
			self.turn_complete(turn_direction * 3 * delta)
		
		# If we are close enough to our destination or our next destination is a city and we aren't at the final destination, move on to the next point.
		if self.position.distance_squared_to(next_pos) <= 100:# or ($"..".cities.has(self.path[0]) and len(self.path) > 1):
			
			if $"..".cities.has(self.path[0]) and self.type == "mercantile":
				self.do_transaction()
			self.path.pop_front()
			if len(self.path) == 0:
				self.path = null
				queue_free()
	
		# move_and_slide(get_attempted_movement2(acc, delta))
		rotation = self.orientation

func get_attempted_movement():
	return Vector2(cos(self.orientation), sin(self.orientation)) * self.sailing_speed

func get_attempted_movement2(acc, delta):
	# s = 0.5at^2 + v0t + s0
	return Vector2(cos(self.orientation), sin(self.orientation)) * (self.sailing_speed + 0.5 * acc * delta * delta)
	
func handle_acceleration(acceleration, delta):
	self.sailing_speed = acceleration * delta + self.sailing_speed
	
	if acceleration >= 0:
		 self.sailing_speed += ((acceleration * _max_speed) - self.sailing_speed) * acc_fac * delta
	if acceleration < 0:
		 self.sailing_speed -= ((acceleration * _max_reverse_speed) + self.sailing_speed) * acc_fac * delta

func set_orientation(new_ori):
	self.orientation = fmod(new_ori, PI * 2.0);

func set_sailing_speed(speed):
	self.sailing_speed = clamp(speed, self._max_reverse_speed, self._max_speed)

func get_orientation():
	return self.orientation

func turn_complete(orientation_change_delta):
	# Use this function if the orientation change is already
	# multiplied by the delta

	# fac is how close you are to the max speed on a scale of 0 to 1
	var fac = self.sailing_speed / _max_speed
	fac = 1.0
	self.set_orientation(self.orientation + orientation_change_delta * fac)

func turn(orientation_change, delta):
	# Use this to turn a certain number of radians per second.
	var fac = self.sailing_speed / _max_speed
	fac = 1.0
	self.set_orientation(self.orientation + (orientation_change * delta * fac))
	
func do_transaction():
	if self.buy:
		self.dest_city.adjust_price(self.resource, 1)
	else:
		self.dest_city.adjust_price(self.resource, -1)

func destroy():
	self.city.alert(self.dest_city)
	if type == "mercantile":
		# Destroyed ships affect the home city economy
		if buy:
			self.city.adjust_price(self.resource, 2)
		else:
			self.city.adjust_price(self.resource, -2)
	queue_free()
