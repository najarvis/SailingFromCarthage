extends Node

var states = {"Idle": IdleState.new(),
              "Sailing": SileToDestState.new()}
var current_state_name = "Idle"
var current_state = null

func _ready():
	if not current_state_name in states:
		print("Invalid state name")
		return

	current_state = states[current_state_name]
	

func _process(delta):
	think(delta)
	
func think(delta):
	current_state = null
	if not current_state_name in states:
		print("Invalid state name")
		return
		
	current_state = states[current_state_name]
	current_state.do_actions(delta)
	
	
class state:
	
	var player = null
	
	func get_name(): # Must be overridden
		assert(false)
		
	func enter(player, state_data):
		self.player = player
		self.state_data = state_data
		
	func do_actions(delta):
		pass
		
	func exit():
		pass
		
class IdleState extends state:
	
	func get_name():
		return "Idle"
		
class SailToDestState extends state:
	
	func get_name():
		return "Sailing"
		
	func do_actions(delta):
		var dest = self.state_data["destination"]
		var direction = dest - self.player.position
		var ori = atan2(direction.y, direction.x)
		self.player.turn(clamp(ori-player.get_orientation, -3.0, 3.0), delta)
		
	func exit():
		var min_radius = 8.0
		var dest = self.state_data["destination"]
		
		if pow(dest.x - player.position.x, 2) + pow(dest.y - player.position.y, 2) < min_radius * min_radius:
			return "Idle"
		
		
		