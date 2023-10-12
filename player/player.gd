extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -170.0
var is_dig = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
		var data = tile_map.get_cell_tile_data(0, checked_cell)
		if data == null:
			return
		var block_hp = data.get_custom_data("hp")
		tile_map.array[checked_cell.x][checked_cell.y] += 1
		is_dig = true
		if tile_map.array[checked_cell.x][checked_cell.y] >= block_hp:
			tile_map.erase_cell(0, checked_cell)
			tile_map.array[checked_cell.x][checked_cell.y] = 0
		
