extends TileMap

const TILE_LAYER = 1
const FOG_LAYER = 2
const FOG_TILE = Vector2i.ZERO
var block_hp = [];

func _enter_tree():
	fill_fog()

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 60
	var map_size : Rect2 = get_used_rect()
	for i in map_size.size.x:
		block_hp.append([]);
		for j in map_size.size.y:
			block_hp[i].append(0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		var map_coordi = local_to_map(mouse_pos)
		var cell = get_cell_tile_data(TILE_LAYER, map_coordi)
		print(cell)

func fill_fog():
	var map_size : Rect2 = get_used_rect()
	for x in map_size.size.x:
		for y in map_size.size.y:
			set_cell(FOG_LAYER, Vector2i(x, y), 0, FOG_TILE)

func reveal_fog(global_pos : Vector2):
	var tile_pos = local_to_map(global_pos)
	var map_size : Rect2 = get_used_rect()
	var fog = get_surrounding_cells(tile_pos)
	print(fog)
	while fog.size() > 0:
		var pos = fog.pop_back()
		var fog_tile = get_cell_tile_data(FOG_LAYER, pos)
		if fog_tile != null and get_cell_tile_data(TILE_LAYER, pos) == null:
			fog.append_array(get_surrounding_cells(pos))
		if fog_tile != null:
			erase_cell(FOG_LAYER, pos)
	
