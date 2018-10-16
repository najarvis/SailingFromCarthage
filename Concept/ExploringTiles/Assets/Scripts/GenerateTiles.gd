extends TileMap



export var map_w = 64

func _ready():
	var map_img = Image.new()
	map_img.load("res://Assets/map.png")

	var w = map_img.get_width()
	var h = map_img.get_height()
	var aspect_ratio = float(w) / h
	var map_h = int(map_w / aspect_ratio)
	
	map_img.lock()
	for x in range(map_w):
		for y in range(map_h):
			var x_coord = int((float(x) / map_w) * w)
			var y_coord = int((float(y) / map_h) * h)
			var col = map_img.get_pixel(x_coord, y_coord)
			var tile_num
			if col.gray() < 0.3:
				tile_num = 1
			elif col.gray() < 0.6:
				tile_num = 0
			else:
				tile_num = 2
			set_cell(x, y, tile_num)
			
	map_img.unlock()