extends StaticBody2D


var hp = 5

func _process(delta):
	if hp <= 0:
		queue_free()
