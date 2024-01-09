extends TileMap

const tile_size = 16

func _ready():
	pass#hide

func get_tile_name(current_pos:Vector2):
	var tile_coord = current_pos / tile_size
	return tile_set.tile_get_name(get_cellv(tile_coord))

func get_spawn_positions():
	var white_spawns = get_used_cells_by_id(0)
	var red_spawns = get_used_cells_by_id(5)
	var blue_spawns = get_used_cells_by_id(10)
	var yellow_spawns = get_used_cells_by_id(15)
	var arr = [white_spawns, red_spawns, blue_spawns, yellow_spawns]
	for i in arr:
		for j in range(i.size()):
			i[j] = map_to_world(i[j])
	return arr

func get_arrow_dict(team:int): # use Enemy class team name constant
	var idx_offset = 5 * team # 5 tiles per team
	var dict = {}
	
	var up_arrows = get_used_cells_by_id(1 + idx_offset)
	var left_arrows = get_used_cells_by_id(2 + idx_offset)
	var down_arrows = get_used_cells_by_id(3 + idx_offset)
	var right_arrows = get_used_cells_by_id(4 + idx_offset)
	
	for i in up_arrows: dict[map_to_world(i)] = "Up"
	for i in left_arrows: dict[map_to_world(i)] = "Left"
	for i in down_arrows: dict[map_to_world(i)] = "Down"
	for i in right_arrows: dict[map_to_world(i)] = "Right"
	return dict # my code sucks
