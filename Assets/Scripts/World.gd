extends Node

var cities = {}

var city_class = preload("res://Assets/Scripts/City.gd")
var selected_city

var won = false
var won_lifetime = 5.0

func _ready():
	set_up_camera()
	
	var city_img = ImageTexture.new()
	city_img.load("res://Assets/Tiles/CityTile.png")
	
	var map = $TileMap.get_used_cells()
	for location in map:
		var city = $TileMap.get_cellv(location) == 16
		if city:
			var new_city = city_class.new()
			new_city.assign_world(self)
			new_city.tile_location = location
			cities[location] = new_city
	
	print(cities)

func _process(delta):
	update_cities(delta)
	if won:
		
		get_node("CanvasLayer/PlayerInformation").hide()
		won_lifetime -= delta
		if won_lifetime <= 0:
			get_tree().paused = false
			get_tree().change_scene("res://Scenes/MainMenu.tscn")

func go_to_city(pos):
	print("In city")
	var city_coord = $TileMap.world_to_map(pos)
	if not cities.has(city_coord):
		print(city_coord)
		return
	selected_city = cities[city_coord]

	# Force the player to face away from a city after docking.
	var center = get_center_pos(to_coord(pos))
	var diff = pos - center
	$Player.s.sailing_speed = 0.0
	$Player.s.set_orientation(atan2(diff.y, diff.x)) # Reverse
	
	get_tree().paused = true
	get_node("CanvasLayer/CityTradeScreen").show()
	get_node("CanvasLayer/PlayerInformation").hide()
	$CanvasLayer/CityTradeScreen.update_text(selected_city)

func win_game():
	get_tree().paused = true
	$CanvasLayer/WinScreen.show()
	won = true

func update_cities(delta):
	for city_loc in cities:
		var city = cities[city_loc]
		if rand_range(0, 500) < 1:
			var rand_location = cities.keys()[randi() % len(cities)]
			if rand_location != city_loc:
				city.create_ship(rand_location)
		city.response_timer -= delta
	
func leave_city():
	get_tree().paused = false
	get_node("CanvasLayer/CityTradeScreen").hide()
	get_node("CanvasLayer/PlayerInformation").show()
	
func to_coord(pos):
	# Converts an in-game position into a tile_map coordinate.
	var cell_size = $TileMap.cell_size
	return Vector2(floor(pos.x / cell_size.x), floor(pos.y / cell_size.y))
	
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
	# This gets the limits for the camera. Since the map has a 1-wide strip of grass around the outside
	# (so the player and other entities can't get out), we don't want to include that in our calculations.
	var map_limits = $TileMap.get_used_rect()
	var cell_size = $TileMap.cell_size
	return [(map_limits.position.x + 1) * cell_size.x,
	        (map_limits.end.x - 1) * cell_size.x,
			(map_limits.position.y + 1) * cell_size.y,
			(map_limits.end.y - 1) * cell_size.y]

func get_closest_point(pos, curve):
	return curve.get_closest_point(pos)

func get_player():
	return $Player

func serialize():
	# This function eventually will be used with saving / loading
	pass
	
func save_game():
	var text = "TEMPLATE"
	var file = File.new()
	file.open("user://save_game.txt", file.WRITE)
	file.store_string(text)
	file.close()
	