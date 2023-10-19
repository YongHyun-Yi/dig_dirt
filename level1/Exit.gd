extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("PlayerDetector").body_entered.connect(get_parent().game_clear)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_entered(body):
	#var player: Player = body
	#player.
	pass
