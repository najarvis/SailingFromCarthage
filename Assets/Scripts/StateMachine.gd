extends Node

var states = {"Idle": IdleState.new()}
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
		
	func enter(player):
		self.player = player
		
	func do_actions(delta):
		pass
		
	func exit():
		pass
		
class IdleState extends state:
	
	func get_name():
		return "Idle"