extends Label

func _ready():
	var map = get_parent()
#	print(map)
	#var size = calculate_bounds(map)	
	var size = map.get_used_rect()
#	print("map.get_used_rect()", size)
#	print("map.cell_size()", map.cell_size)
	var new_size = Vector2(
		size.get_center().x * map.cell_size.x - (get_rect().size.x / 2),
		size.get_center().y * map.cell_size.y - (get_rect().size.y / 2))
#	print("new_position", new_size)
	set_position(new_size)
	#print(size.y)

#func calculate_bounds(tilemap):
#	var min_x = 0
#	var min_y = 0
#	var max_x = 0
#	var max_y = 0
#	var tile_size = tilemap.cell_size
#	var used_cells = tilemap.get_used_cells()
#	for pos in used_cells:
#		if pos.x < min_x:
#			min_x = int(pos.x)
#		elif pos.x > max_x:
#			max_x = int(pos.x)
#		if pos.y < min_y:
#			min_y = int(pos.y)
#		elif pos.y > max_y:
#			max_y = int(pos.y)
#
#	var boundrect =  Rect2(
#		Vector2(min_x, min_y),
#		Vector2(max_x - min_x, max_y - min_y)
#	)
#	return boundrect
