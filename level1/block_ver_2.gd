extends Area2D

@export var speed = 100
var movable = false

signal my_signal

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.play("RESET")
	movable = true
	$CollisionShape2D.disabled = false
	emit_signal("my_signal", 42)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if movable:
		global_position.y += speed * delta
	pass

func _on_body_entered(body):
	print(body.get_class())
	if body.is_class("CharacterBody2D"):
		var character : Player = body
		var dir = (character.global_position - global_position).normalized()
		var angle = dir.dot(Vector2.DOWN)
		if angle > 0.95:
			character._gameover()
		if angle <= 0.95:
			character._knock_back(dir.x)

		get_tree()
	elif body.is_class("TileMap"):
		var tileMap : TileMap = body
		var cellPos = tileMap.local_to_map(global_position)
		tileMap.set_cell(0, cellPos, 0, Vector2i(2, 0))
		queue_free()
		