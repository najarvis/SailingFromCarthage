extends Panel

var current_city

func _ready():
	pass
	
func update_text(city):
	var player = get_tree().get_root().get_node("World/Player")
	$"PlayerCoin".clear()
	$"PlayerCoin".add_text(str(stepify(player.coin, 0.01)))
	
	current_city = city
	$"FoodControl/FoodCost".clear()
	$"FoodControl/FoodCost".add_text(str(stepify(city.get_price("FOOD"), 0.01)))
	
	var has_food = player.resources.has("FOOD")
	$"FoodControl/FoodQuantity".clear()
	if (has_food):
		$"FoodControl/FoodQuantity".add_text("In inventory: " + str(player.resources["FOOD"]))
	else:
		$"FoodControl/FoodQuantity".add_text("In inventory: 0")
	
	$"WoodControl/WoodCost".clear()
	$"WoodControl/WoodCost".add_text(str(stepify(city.get_price("WOOD"), 0.01)))
	
	var has_wood = player.resources.has("WOOD")
	$"WoodControl/WoodQuantity".clear()
	if (has_wood):
		$"WoodControl/WoodQuantity".add_text("In inventory: " + str(player.resources["WOOD"]))
	else:
		$"WoodControl/WoodQuantity".add_text("In inventory: 0")
	
	$"MetalControl/MetalCost".clear()
	$"MetalControl/MetalCost".add_text(str(stepify(city.get_price("METAL"), 0.01)))
	
	var has_metal = player.resources.has("METAL")
	$"MetalControl/MetalQuantity".clear()
	if (has_metal):
		$"MetalControl/MetalQuantity".add_text("In inventory: " + str(player.resources["METAL"]))
	else:
		$"MetalControl/MetalQuantity".add_text("In inventory: 0")
	
	$"ToolsControl/ToolsCost".clear()
	$"ToolsControl/ToolsCost".add_text(str(stepify(city.get_price("TOOLS"), 0.01)))
	
	var has_tools = player.resources.has("TOOLS")
	$"ToolsControl/ToolsQuantity".clear()
	if (has_tools):
		$"ToolsControl/ToolsQuantity".add_text("In inventory: " + str(player.resources["TOOLS"]))
	else:
		$"ToolsControl/ToolsQuantity".add_text("In inventory: 0")
		
	$"SaltControl/SaltCost".clear()
	$"SaltControl/SaltCost".add_text(str(stepify(city.get_price("SALT"), 0.01)))
	
	var has_salt = player.resources.has("SALT")
	$"SaltControl/SaltQuantity".clear()
	if (has_salt):
		$"SaltControl/SaltQuantity".add_text("In inventory: " + str(player.resources["SALT"]))
	else:
		$"SaltControl/SaltQuantity".add_text("In inventory: 0")