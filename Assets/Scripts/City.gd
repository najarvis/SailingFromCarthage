extends Node

var base_prices = {
	"FOOD": 10,
	"WOOD": 20,
	"METAL": 50,
	"TOOLS": 100,
	"SALT": 50	
}

var price_modifiers = {
	"FOOD": 1.0,
	"WOOD": 1.0,
	"METAL": 1.0,
	"TOOLS": 1.0,
	"SALT": 1.0
}

var world
var tile_location
var city_size
var ship_scene = preload("res://Assets/Entities/PatrolShip.tscn")

var response_timer

func _init():
	randomize()
	
	var modifier_base
	var modifier
	city_size = 1
	response_timer = 0.0
	
	for i in range(len(price_modifiers)):
		modifier_base = randf()
		modifier = 5.0 * pow((modifier_base - 0.5), 3)
		price_modifiers[price_modifiers.keys()[i]] += modifier

func assign_world(world):
	self.world = world

func get_price(resource, value="default"):
	#if value == "default":
	return base_prices[resource] * price_modifiers[resource]
	if value == "buy":
		return base_prices[resource] * price_modifiers[resource] * 1.2 # 20% tariff
	elif value == "sell":
		return base_prices[resource] * price_modifiers[resource] * 0.8 # 20% tariff
	
func adjust_price(resource, direction):
	price_modifiers[resource] *= 1 + direction * 0.01
	city_size += 1
	# print(price_modifiers[resource])

func create_trade_route(tm, destination_city):
	var to_path = tm.do_astar(self.tile_location, destination_city)
	var whole_path = to_path.duplicate()
	for cell in to_path:
		whole_path.insert(len(to_path), cell)
	# print(whole_path)
	return whole_path

func create_ship(destination_city, type="mercantile"):
	var tm = self.world.find_node("TileMap")
	var path = create_trade_route(tm, destination_city)
	var new_ship = ship_scene.instance()
	
	if type == "mercantile":
		var rand_resource = base_prices.keys()[randi() % len(base_prices)]
		var rand_buy = randi() % 2 == 0
		new_ship.init(self.tile_location * tm.cell_size, path, self, type, self.world.cities[destination_city], rand_resource, rand_buy)
	else:
		new_ship.init(self.tile_location * tm.cell_size, path, self, type, self.world.cities[destination_city])
	self.world.call_deferred("add_child", new_ship)

func alert(destination_city):
	if response_timer <= 0:
		create_ship(destination_city.tile_location, "warrior")
		response_timer = 10 - (log(city_size) / log(2))

