extends TileMap

export var map_w = 32

var images = {}
var cities = []

# keys are a tuple the 'trueness' of each corner in 
# clockwise order (with black being true because I'm
# dumb). for example, 'BottomLeft' would be (0, 0, 0, 1)

func init_dict():
	images[[true, true, true, true]] = 0
	images[[false, false, false, false]] = 1
	
	# --
	images[[true, true, false, false]] = 2
	images[[false, false, true, true]] = 3
	images[[true, false, false, true]] = 4
	images[[false, true, true, false]] = 5
	
	# --

	images[[true, false, false, false]] = 6
	images[[false, true, false, false]] = 7
	images[[false, false, true, false]] = 8
	images[[false, false, false, true]] = 9
	
	# -- 

	images[[false, true, true, true]] = 10
	images[[true, false, true, true]] = 11
	images[[true, true, false, true]] = 12
	images[[true, true, true, false]] = 13
	
	# --
	
	images[[true, false, true, false]] = 14
	images[[false, true, false, true]] = 15
	
	print(images)

func auto_map():
	init_dict()
	
	var map_img = Image.new()
	map_img.load("res://Assets/Map/map_small.png")
			
	var tile_num
	var w = map_img.get_width()
	var h = map_img.get_height()
	var aspect_ratio = float(w) / h
	var map_h = int(map_w / aspect_ratio)

	var step_x = int(float(w) / map_w)
	var step_y = int(float(h) / map_h)
	
	map_img.lock()
	for x in range(map_w - 1):
		for y in range(map_h - 1):

			var x_coord = int((float(x) / map_w) * w)
			var y_coord = int((float(y) / map_h) * h)

			var top_left = map_img.get_pixel(x_coord, y_coord).gray() > 0.3
			var top_right = map_img.get_pixel(x_coord + step_x, y_coord).gray() > 0.3
			var bottom_right = map_img.get_pixel(x_coord + step_x, y_coord + step_y).gray() > 0.3
			var bottom_left = map_img.get_pixel(x_coord, y_coord + step_y).gray() > 0.3

			tile_num = images[[top_left, top_right, bottom_right, bottom_left]]
			set_cell(x, y, tile_num)
			
	map_img.unlock()
	
func _ready():
	# auto_map()
	pass
	
func get_player_tile(pos):
	var tile_pos = world_to_map(pos)
	return get_cell(tile_pos.x, tile_pos.y)