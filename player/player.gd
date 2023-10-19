class_name Player
extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -150.0
var is_dig = false

signal damage_block(pos: Vector2i, power: int)

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
	if is_on_floor() and body is LevelMap:
		var map : LevelMap = body;
		var checked_cell = map.local_to_map(get_node(dir_name).global_position)
		is_dig = map.damage_block(checked_cell, 1)
		#map.damage_block(checked_cell, 1)

func gameover():
	get_tree().reload_current_scene()

func knock_back(right):
	if right > 0:
		velocity.x = SPEED * 2;
	else:
		velocity.x = SPEED * -2;
	velocity.y = -80
	move_and_slide()
