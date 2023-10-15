extends TileMap

const TILE_LAYER = 1;
var array = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.max_fps = 60
	var map_size : Rect2 = get_used_rect()
	for i in map_size.size.x:
		array.append([]);
		for j in map_size.size.y:
			array[i].append(0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		var map_coordi = local_to_map(mouse_pos)
		var cell = get_cell_tile_data(TILE_LAYER, map_coordi)
		print(cell)
	pass

func _print(number):
	print(number)
