extends TextureButton

func _ready():
	pass

func buy_resource(res):
	get_tree().get_root().get_node("World").buy_resource(res)
	
func sell_resource(res):
	get_tree().get_root().get_node("World").sell_resource(res)
	
func buy_food():
	buy_resource("FOOD")
	
func sell_food():
	sell_resource("FOOD")
	
func buy_wood():
	buy_resource("WOOD")
	
func sell_wood():
	sell_resource("WOOD")
	
func buy_metal():
	buy_resource("METAL")
	
func sell_metal():
	sell_resource("METAL")
	
func buy_tools():
	buy_resource("TOOLS")

func sell_tools():
	sell_resource("TOOLS")
	
func buy_salt():
	buy_resource("SALT")

func sell_salt():
	sell_resource("SALT")