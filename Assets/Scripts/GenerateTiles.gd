extends TileMap

export var map_w = 32

var images = {}
var cities = []
var neighbors = {}

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
	
func generate_neighbors():
	var used_cells = get_used_cells()
	for cell in used_cells:
		#if not get_cellv(cell) in [1, 16]:
		#	continue

		neighbors[cell] = []
		for neighbor_offset in [Vector2(-1, 0), Vector2(0, -1), Vector2(1, 0), Vector2(0, 1),
		                        Vector2(-1, -1), Vector2(1, -1), Vector2(1, 1), Vector2(-1, 1)]:
			var neighbor = cell + neighbor_offset
			if get_cellv(neighbor) in [1, 16]:
				neighbors[cell].append(neighbor)
				
		if len(neighbors[cell]) == 0:
			neighbors.erase(cell)

func _ready():
	# auto_map()
	generate_neighbors()
	pass
	
func get_player_tile(pos):
	var tile_pos = world_to_map(pos)
	return get_cellv(tile_pos)

func heuristic(from, to):
	# Manhattan distance
	return abs(from.x - to.x) + abs(from.x - to.x)

func get_key_from_min_value(dict, open_set):
	# Pretty close to infinity.
	var min_val = 3.402823e+38
	var selected = null
	for key in dict:
		if dict[key] < min_val and open_set.has(key):
			min_val = dict[key]
			selected = key
			
	return selected

func dist(a, b):
	if heuristic(a, b) == 2:
		return 1.41421356237
	return 1

func do_astar(start, end):
	# Returns a list of open-water tile coordinates in a path from start to end.
	#if get_cellv(start) == -1 or get_cellv(end) == -1:
	if get_cellv(end) == -1:
		print("Cells don't exist!")
		return [] # no path to a non-existant node.
		
	var closed_set = []
	var open_set = [start]
	var cameFrom = {}
	
	var gScore = {}
	gScore[start] = 0
	
	var fScore = {}
	fScore[start] = heuristic(start, end)
	
	var current = null
	
	while len(open_set) > 0:
		current = get_key_from_min_value(fScore, open_set)
		if current == end:
			var path = [current]
			while cameFrom.has(current):
				current = cameFrom[current]
				path.push_front(current)
			return path
			
		open_set.remove(open_set.find(current))
		closed_set.append(current)
	
		if not neighbors.has(current):
			print("Not in neighbors!")
			return []
		for neighbor in neighbors[current]:

			if closed_set.find(neighbor) != -1:
				continue

			if not gScore.has(neighbor):
				gScore[neighbor] = 3.402823e+38

			var tentative_gScore = gScore[current] + dist(current, neighbor)
			if open_set.find(neighbor) == -1:
				open_set.append(neighbor)
			elif tentative_gScore >= gScore[neighbor]:
				continue
				
			cameFrom[neighbor] = current
			gScore[neighbor] = tentative_gScore
			fScore[neighbor] = gScore[neighbor] + heuristic(neighbor, end)
	
	print("No path found!")
	return []



