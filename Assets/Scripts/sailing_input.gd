extends "ship_class.gd"

var COIN_GOAL = 1500

var s
var in_city = false
var coin
var health
var alive = true
var path

var death_sound
var hurt_sound

export var initial_pos = Vector2(0, 0)

var cell_size = 32 

var resources = {
	"FOOD": 10,
	"WOOD": 5,
	"METAL": 1,
	"TOOLS": 1,
	"SALT": 1
}
var state = "MANUAL" # Other state = "AUTOMATIC"

var invincibility_timer = 0.0

func _ready():
	death_sound = load("res://Assets/Sfx/Destroyed.wav")
	hurt_sound = load("res://Assets/Sfx/Hurt.wav")
	self.s = Ship.new(initial_pos * cell_size)
	position += self.s.pos
	self.health = 3
	
	self.coin = 50
	self.set_meta("player", true)
	# self.destination = null
	# self.path = null
	update_ui()
	
func _process(delta):
	if alive:
		var acc = 0
		if self.state == "MANUAL":
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
				
			move_and_slide(self.s.get_attempted_movement2(acc, delta))

		elif self.state == "AUTOMATIC":
			if self.path == null or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				self.state = "MANUAL"
				
			acc = 1.0
			self.s.handle_acceleration(acc, delta)
			var next_pos = $"../TileMap".map_to_world(array_to_vec(self.path[0])) + ($"../TileMap".cell_size / 2)
			var move_dir = (next_pos - self.position).normalized()
			self.position += move_dir * delta * 100
			var goal_orientation = atan2(move_dir.x, -move_dir.y) - PI / 2
			if goal_orientation != self.s.orientation:
				var turn_direction = (goal_orientation - self.s.orientation) / abs(goal_orientation - self.s.orientation)
				self.s.turn_complete(turn_direction * 3 * delta)
			
			# If we are close enough to our destination or our next destination is a city and we aren't at the final destination, move on to the next point.
			if self.position.distance_squared_to(next_pos) <= 100 or ($"..".cities.has(self.path[0]) and len(self.path) > 1):
				self.path.pop_front()
				if len(self.path) == 0:
					self.state = "MANUAL"
					self.path = null
		
		# self.s.update(delta)
		# print(self.s.sailing_speed / self.s._max_speed)
		#$Player/Particles2D.set_amount(int(32.0 * (self.s.sailing_speed / self.s._max_speed)))
		#position = self.s.pos
		
		#if (self.s.sailing_speed > 0 and not $AudioStreamPlayer2D.playing):
		#	$AudioStreamPlayer2D.play()
		rotation = self.s.orientation
		
		# print(get_node("../TileMap").get_player_tile(position))
		if get_node("../TileMap").get_player_tile(position) == 16 and not in_city:
			# Entering city
			in_city = true
			self.path = null
			self.state = "MANUAL"
			get_node("..").go_to_city(position)
		
		if get_node("../TileMap").get_player_tile(position) != 16 and in_city:
			# Leaving city
			in_city = false
			
		if invincibility_timer > 0:
			$Player.animation = "Invincible"
			invincibility_timer -= delta
		else:
			$Player.animation = "Idle"
			
	else:
		# If you aren't alive... die.
		die()
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed == true:
		var pos = event.position + self.position - (get_viewport().size / 2) + ($Player/Camera2D.get_camera_screen_center() - self.position)
		# print("Camera: ", $Player/Camera2D.get_camera_screen_center())
		# print(pos)
		set_destination(pos, true)
	
func update_ui():
	$"../CanvasLayer/PlayerInformation/GoldCount".text = "GOLD: " + str(int(self.coin))
	$"../CanvasLayer/PlayerInformation/HealthProgress".value = self.health

func buy_resource(resource, cost):
	if not self.resources.has(resource):
		self.resources[resource] = 1
	else:
		self.resources[resource] += 1
		
	self.coin -= cost
	update_ui()
	
func sell_resource(resource, cost):
	self.resources[resource] -= 1
	self.coin += cost
	if self.coin >= COIN_GOAL:
		$"..".win_game()
	update_ui()
	
func damage():
	if self.invincibility_timer <= 0:
		self.health -= 1
		if self.health <= 0:
			$AudioStreamPlayer2D.stream = death_sound
			$AudioStreamPlayer2D.play()
			alive = false
			
			$Player.animation = "Destroyed"
			# Dead
		else:
			$AudioStreamPlayer2D.stream = hurt_sound
			$AudioStreamPlayer2D.play()
			
		self.invincibility_timer = 2.0
		update_ui()

func die():
	if not $AudioStreamPlayer2D.playing:
		get_tree().change_scene("res://Scenes/Sailing.tscn")

func vec_to_array(vec):
	return [vec.x, vec.y]

func array_to_vec(array):
	return Vector2(array[0], array[1])

func set_destination(pos, world):
	
	var player_map_coords = $"../TileMap".world_to_map(self.position)
	var dest_map_coords = $"../TileMap".world_to_map(pos)
	#print(self.position, player_map_coords)
	#print(pos, dest_map_coords)
	var attempted_path = $"../TileMap".do_astar(player_map_coords, dest_map_coords)
	if len(attempted_path) > 0:
		self.state = "AUTOMATIC"
		self.path = attempted_path
		#print(self.path)