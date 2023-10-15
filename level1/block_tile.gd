extends Area2D

@export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position.y += speed * delta
	pass

func _on_body_entered(body):
	print(body.get_class())
	if body.is_class("CharacterBody2D"):
		print("CharacterBody2D")
	elif body.is_class("TileMap"):
		var tileMap : TileMap = body
		var cellPos = tileMap.local_to_map(global_position)
		tileMap.set_cell(0, cellPos, 0, Vector2i(2, 0))
		queue_free()
		
