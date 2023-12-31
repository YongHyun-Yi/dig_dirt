class_name Player
extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -150.0
var is_dig = false
var dead = false : set = set_dead

var drill_mode = false

signal player_dead

signal damage_block(pos: Vector2i, power: int)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	emit_signal("reveal_fog", global_position)

func _physics_process(delta):
	
	if drill_mode == false and Input.is_action_pressed("drill_mode"):
		drill_mode = true
		velocity.y = 0
	elif drill_mode == true and not Input.is_action_pressed("drill_mode"):
		drill_mode = false
	
	# Add the gravity.
	if not drill_mode and not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if not drill_mode and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("ui_down"):
		set_collision_mask_value(3, false)
	elif Input.is_action_just_released("ui_down"):
		set_collision_mask_value(3, true)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if not drill_mode:
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = lerp(velocity.x, direction * SPEED, .18)
		else:
			velocity.x = lerp(velocity.x, 0.0, .2)
		if is_dig:
			velocity.x = SPEED * 1 * -direction
			is_dig = false
	else:
		var direction : Vector2
		direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		direction.normalized()
		velocity += direction * SPEED * delta * 5
		if is_dig:
			velocity.x = SPEED * 0.5 * -direction.x
			velocity.y = SPEED * 0.5 * -direction.y
			is_dig = false

	move_and_slide()

func _set_is_dig(value):
	is_dig = value

func wall_detect(body, dir_name):
	#if is_on_floor() and body is LevelMap:
	if drill_mode or is_on_floor() and body is LevelMap:
		var map : LevelMap = body;
		var checked_cell = map.local_to_map(get_node(dir_name).global_position)
		is_dig = map.damage_block(checked_cell, 1)
		#map.damage_block(checked_cell, 1)

func set_dead(value: bool):
	dead = value
	emit_signal("player_dead")

func knock_back(right):
	if right > 0:
		velocity.x = SPEED * 2;
	else:
		velocity.x = SPEED * -2;
	velocity.y = -80
	move_and_slide()
