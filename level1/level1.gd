class_name LevelMap
extends TileMap

const TILE_LAYER = 1
const FOG_LAYER = 2
const FOG_TILE = Vector2i.ZERO
const TILE_MAP = 0
const TILE_MAP_FOG = 1
var block_hp = [];

@export var block_scene : PackedScene
@export var player : NodePath

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
	var player_tile_pos = local_to_map(get_node(player).global_position)
	reveal_fog(player_tile_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		var map_coordi = local_to_map(mouse_pos)
		var cell = get_cell_tile_data(TILE_LAYER, map_coordi)

func fill_fog():
	var map_size : Rect2 = get_used_rect()
	var margin = 20
	var tiles = []
	for x in range(map_size.position.x - margin, map_size.end.x + margin):
		for y in range(map_size.position.y - margin, map_size.end.y + margin):
			tiles.append(Vector2i(x, y))
	set_cells_terrain_connect(FOG_LAYER, tiles, TILE_MAP, TILE_MAP_FOG)

func get_surrounding_9cells(pos : Vector2i):
	var cells = []
	cells.append(pos + Vector2i(0, 0))
	cells.append(pos + Vector2i(1, 0))
	cells.append(pos + Vector2i(-1, 0))
	cells.append(pos + Vector2i(0, 1))
	cells.append(pos + Vector2i(0, -1))
	cells.append(pos + Vector2i(1, 1))
	cells.append(pos + Vector2i(-1, 1))
	cells.append(pos + Vector2i(1, -1))
	cells.append(pos + Vector2i(-1, -1))
	return cells

func reveal_fog(tile_pos: Vector2i):
	var fog = get_surrounding_9cells(tile_pos)
	while fog.size() > 0:
		var pos = fog.pop_back()
		var fog_tile = get_cell_tile_data(FOG_LAYER, pos)
		var tile = get_cell_tile_data(TILE_LAYER, pos)
		if fog_tile != null and tile == null:
			fog.append_array(get_surrounding_9cells(pos))
		if fog_tile != null:
			if tile == null or tile.get_custom_data("is_wall") == false:
				set_cells_terrain_connect(FOG_LAYER, [pos], TILE_MAP, -1, false)

func try_drop_tile(tile_pos: Vector2i):
	var cell = get_cell_tile_data(TILE_LAYER, tile_pos)
	if cell == null:
		return true
	if cell.get_custom_data("can_drop") == true:
		var pos = map_to_local(tile_pos)
		var block = block_scene.instantiate()
		block.global_position = pos
		get_node("/root/main").add_child(block)
		
		#await get_tree().create_timer(1).timeout
		erase_cell(TILE_LAYER, tile_pos)
		var up_cell_pos = tile_pos + Vector2i.UP
		try_drop_tile(up_cell_pos)

func damage_block(tile: Vector2i, power: int) -> bool:
	var data = get_cell_tile_data(TILE_LAYER, tile)
	if data == null:
		return false
	var block_hp = data.get_custom_data("hp")
	if block_hp == 0:
		return false
	self.block_hp[tile.x][tile.y] += 1
	if self.block_hp[tile.x][tile.y] >= block_hp:
		set_cells_terrain_connect(TILE_LAYER, [tile], 0, -1, false)
		reveal_fog(tile)
		self.block_hp[tile.x][tile.y] = 0
		var up_cell_pos = tile + Vector2i.UP
		try_drop_tile(up_cell_pos)

	return true


func _on_player_player_dead():
	get_tree().reload_current_scene()

func game_clear(body):
	print("Clear~!")
	get_tree().reload_current_scene()

