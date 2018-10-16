extends Node

var cities = {}

var city_class = preload("res://Assets/Scripts/City.gd")
var selected_city

func _ready():
	pass

func go_to_city(pos):
	var city_coord = to_coord(pos)
	if cities.has(city_coord):
		selected_city = cities[city_coord]
	else:
		selected_city = city_class.new()
		cities[city_coord] = selected_city

	$Player.s.sailing_speed = 0.0
	$Player.s.turn_complete(PI)
	get_tree().paused = true
	get_node("CanvasLayer/CityTradeScreen").show()
	$CanvasLayer/CityTradeScreen.update_text(selected_city)
	
func leave_city():
	get_tree().paused = false
	get_node("CanvasLayer/CityTradeScreen").hide()
	
func to_coord(pos):
	var cell_size = $TileMap.cell_size
	return [floor(pos.x / cell_size.x), floor(pos.y / cell_size.y)]

func buy_resource(resource):
	var p = selected_city.get_price(resource)
	if p <= $Player.coin:
		$Player.buy_resource(resource, p)

	$CanvasLayer/CityTradeScreen.update_text(selected_city)
	
func sell_resource(resource):
	var p = selected_city.get_price(resource)
	if $Player.resources.has(resource):
		if $Player.resources[resource] > 0:
			$Player.sell_resource(resource, p)

	$CanvasLayer/CityTradeScreen.update_text(selected_city)
