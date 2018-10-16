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

func _init():
	randomize()
	
	var modifier_base
	var modifier
	
	for i in range(len(price_modifiers)):
		modifier_base = randf()
		modifier = 5.0 * pow((modifier_base - 0.5), 3)
		price_modifiers[price_modifiers.keys()[i]] += modifier

func get_price(resource):
	return base_prices[resource] * price_modifiers[resource]