extends TileMap


var array = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	var map_size : Rect2 = get_used_rect()
	for i in map_size.size.x:
		array.append([]);
		for j in map_size.size.y:
			array[i].append(0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
