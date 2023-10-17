class_name Player
extends CharacterBody2D

const TILE_LAYER = 1;
const SPEED = 100.0
const JUMP_VELOCITY = -170.0
var is_dig = false

signal reveal_fog(reveal_pos : Vector2)

@export var block_scene : PackedScene

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	emit_signal("reveal_fog", global_position)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_down"):
		set_collision_mask_value(3, false)
	elif Input.is_action_just_released("ui_down"):
		set_collision_mask_value(3, true)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, .18)
	else:
		velocity.x = lerp(velocity.x, 0.0, .2)
	if is_dig:
		velocity.x = SPEED * 1 * -direction
		is_dig = false

	move_and_slide()


func wall_detect(body, dir_name):
	if body.is_class("TileMap") and is_on_floor():
		var tile_map : TileMap = body;
		var checked_cell = tile_map.local_to_map(get_node(dir_name).global_position)
		var data = tile_map.get_cell_tile_data(TILE_LAYER, checked_cell)
		if data == null:
			return
		var block_hp = data.get_custom_data("hp")
		if block_hp == 0:
			return
		tile_map.block_hp[checked_cell.x][checked_cell.y] += 1
		is_dig = true
		if tile_map.block_hp[checked_cell.x][checked_cell.y] >= block_hp:
			tile_map.set_cells_terrain_connect(TILE_LAYER, [checked_cell], 0, -1, false)
			emit_signal("reveal_fog", get_node(dir_name).global_position)
			tile_map.block_hp[checked_cell.x][checked_cell.y] = 0
			var upCellPos = checked_cell + Vector2i.UP;
			var cell = tile_map.get_cell_tile_data(TILE_LAYER, upCellPos)
			if cell == null:
				return;
			if cell.get_custom_data("can_drop") == true:
				#tile_map.set_cell(0, upCellPos, 0, Vector2i(3, 6))
				#await get_tree().create_timer(.5).timeout
				
				#tile_map.erase_cell(0, upCellPos)

				var pos = tile_map.map_to_local(upCellPos)
				var block = block_scene.instantiate()
				block.global_position = pos
				get_node("/root/main").add_child(block)
				
				await get_tree().create_timer(1).timeout
				tile_map.erase_cell(TILE_LAYER, upCellPos)
				
func _gameover():
	get_tree().reload_current_scene()

func _knock_back(right):
	if right > 0:
		velocity.x = SPEED * 2;
	else:
		velocity.x = SPEED * -2;
	velocity.y = -80
	move_and_slide()
