extends Node

@export var max_hp : int = 10
@onready var cur_hp : int = max_hp

signal dead

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restore(value : int):
	cur_hp += value
	cur_hp = min(cur_hp, max_hp)

func damage(value : int):
	cur_hp -= value
	cur_hp = max(cur_hp, 0)
	if cur_hp == 0:
		emit_signal("dead")
