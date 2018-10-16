extends Node

class Commodity: # 'Resource' was taken
	
	var resource_name = "COMMODITY"
	var base_price = 0
		
class Food extends Commodity:
	
	var resource_name = "FOOD"
	var base_price = 10
	
class Wood extends Commodity:
	
	var resource_name = "WOOD"
	var base_price = 30