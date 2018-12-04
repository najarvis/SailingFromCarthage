extends KinematicBody2D

class Ship:
	# A 'ship' entity is basically any entity that moves only in the direction it is
	# facing (or directly opposite to go in reverse).

	var orientation = 0.0
	var pos
	var sailing_speed
	var target
	var acc_fac = 0.9
	var turn_rate
	
	var _max_speed = 60.0
	var _max_reverse_speed = -30.0
	
	func _init(pos):
		self.pos = pos
		self.sailing_speed = 0.0

		self.target = null

	func update(delta):
		self.pos += get_attempted_movement() * delta
	
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