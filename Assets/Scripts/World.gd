extends Node

var cities = {}

var city_class = preload("res://Assets/Scripts/City.gd")
var selected_city

func _ready():
	set_up_camera()

func go_to_city(pos):
	# Cities are actually generated when you first visit them.
	var city_coord = to_coord(pos)
	if cities.has(city_coord):
		selected_city = cities[city_coord]
	else:
		selected_city = city_class.new()
		cities[city_coord] = selected_city

	# Force the player to face away from a city after docking.
	var center = get_center_pos(to_coord(pos))
	var diff = pos - center
	$Player.s.sailing_speed = 0.0
	$Player.s.set_orientation(atan2(diff.y, diff.x))
	
	get_tree().paused = true
	get_node("CanvasLayer/CityTradeScreen").show()
	$CanvasLayer/CityTradeScreen.update_text(selected_city)
	
func leave_city():
	get_tree().paused = false
	get_node("CanvasLayer/CityTradeScreen").hide()
	
func to_coord(pos):
	# Converts an in-game position into a tile_map coordinate.
	var cell_size = $TileMap.cell_size
	return [floor(pos.x / cell_size.x), floor(pos.y / cell_size.y)]
	
func get_center_pos(cell_coord):
	# Converts a tile_map coordinate to the a position corresponding to the center of the tile it's associated with.
	var size = $TileMap.cell_size
	return Vector2((cell_coord[0] + 0.5) * size.x, (cell_coord[1] + 0.5) * size.y)

func buy_resource(resource):
	var p = selected_city.get_price(resource, "buy")
	if p <= $Player.coin:
		$Player.buy_resource(resource, p)
		selected_city.adjust_price(resource, 1) # Demand up, price up

	$CanvasLayer/CityTradeScreen.update_text(selected_city)
	
func sell_resource(resource):
	var p = selected_city.get_price(resource, "sell")
	if $Player.resources.has(resource):
		if $Player.resources[resource] > 0:
			$Player.sell_resource(resource, p)
			selected_city.adjust_price(resource, -1) # Supply up, price down

	$CanvasLayer/CityTradeScreen.update_text(selected_city)
	
func set_up_camera():
	# Prevent the player from being able to see the edges of the screen.
	$Player/Player/Camera2D.set_limits(get_map_limits())
	
func get_map_limits():
	var map_limits = $TileMap.get_used_rect()
	var cell_size = $TileMap.cell_size
	return [map_limits.position.x * cell_size.x,
	        map_limits.end.x * cell_size.x,
			map_limits.position.y * cell_size.y,
			map_limits.end.y * cell_size.y]
