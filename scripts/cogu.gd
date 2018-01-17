extends KinematicBody2D

var direction = 1
# last states vars
var last_direction = 1

const SPEED = 260
const JUMP_FORCE = 220
const GRAVITY = 140
const MAX_JUMP_OFFSET = 55
var vertical_speed = 0
var jump_offset = 0
var stop_jump = false
var is_colliding_safe = false
var has_to_release_jump_key = false
var played_first_sound = false
var normal

# bullets
var active_bullets = 0

# animation status
var is_shooting = false

var is_landing_sound_playing = false

# scene nodes
onready var shoot = preload("res://game_objects/projectiles/cogu-shoot.tscn")

func _ready():
	set_hidden(true)
	#get_node("Sprite/AnimationPlayer").play("idle")
	
	#set_fixed_process(true)
	#set_process_input(true)	
	
func _input(event):
	if event.is_action_pressed("shoot") and active_bullets < 3:
		get_node("SamplePlayer2D").play("bullet")	
		is_shooting = true
		var bullet = shoot.instance()
		bullet.set_direction(last_direction)
		if normal.y == -1:
			bullet.set_pos(Vector2(get_pos().x + 45 * last_direction, get_pos().y + 7))			
		else:
			bullet.set_pos(Vector2(get_pos().x + 45 * last_direction, get_pos().y))			
		get_parent().add_child(bullet)
		get_node("timers/shoot timer").start()
		active_bullets += 1

func _fixed_process(delta):
	if Input.is_action_pressed("ui_right"):
		direction = 1
		last_direction = 1
	elif Input.is_action_pressed("ui_left"):
		direction = -1
		last_direction = -1
	else:
		direction = 0
	
	# gravity stuff	
	vertical_speed += GRAVITY * delta
	
	if not Input.is_action_pressed("jump"):
		has_to_release_jump_key = false
	
	if Input.is_action_pressed("jump") and not stop_jump and not has_to_release_jump_key:
		is_landing_sound_playing = false
		var cur_frame_force = JUMP_FORCE * delta
		vertical_speed -= cur_frame_force
		jump_offset += cur_frame_force
		if jump_offset > MAX_JUMP_OFFSET: 
			stop_jump = true
	
	vertical_speed = clamp(vertical_speed, -10, 18) # min and max 
	
	# 3 is current game scale for the game objects
	#get_node("Sprite").set_scale(Vector2(last_direction * 3, 3)) vai ficar aqui por motivos de vergonha
	get_node("Sprite").set_flip_h(true if last_direction == -1 else false)
	var movement_remainder = move(Vector2(SPEED * direction * delta, vertical_speed))	
	
	if is_colliding():
		is_colliding_safe = true # because is_colling() itself wasn't returning proper results
		normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainder)
		#print(final_movement)
		vertical_speed = normal.slide(Vector2(0, vertical_speed)).y
		move(final_movement)		
		if normal.y == -1: # if true means that player is colliding			
			if not is_landing_sound_playing:
				if played_first_sound:
					get_node("SamplePlayer2D").play("landing")
				is_landing_sound_playing = true
			stop_jump = false
			played_first_sound = true # MUST turn it off when die
			jump_offset = 0
			if Input.is_action_pressed("jump"): # avoid constant jumping by keep jump button pressed
				has_to_release_jump_key = true
	else:
		is_colliding_safe = false
		# this avoids player trying to jumping while falling
		if not Input.is_action_pressed("jump"):
			has_to_release_jump_key = true
	
	play_proper_animation()
	
func play_proper_animation():
	# handles running and idle animation
	if direction:
		if is_shooting: 
			if get_node("Sprite/AnimationPlayer").get_current_animation() != "running-and-shooting":
				get_node("Sprite/AnimationPlayer").play("running-and-shooting")
		elif get_node("Sprite/AnimationPlayer").get_current_animation() != "running":
			get_node("Sprite/AnimationPlayer").play("running")
	else:
		if is_shooting:
			if get_node("Sprite/AnimationPlayer").get_current_animation() != "shooting":
				get_node("Sprite/AnimationPlayer").play("shooting")
		elif get_node("Sprite/AnimationPlayer").get_current_animation() != "idle": 
			get_node("Sprite/AnimationPlayer").play("idle")
	# handles jumping animation
	if is_colliding_safe == false or (vertical_speed < 0):
		if is_shooting:
			if get_node("Sprite/AnimationPlayer").get_current_animation() != "jumping-and-shooting":
				get_node("Sprite/AnimationPlayer").play("jumping-and-shooting")
		elif get_node("Sprite/AnimationPlayer").get_current_animation() != "jumping":
			get_node("Sprite/AnimationPlayer").play("jumping")
	
	# DO NOT FORGET
	# is_colliding_safe is answering for overall collisions
	# not only for ground based collision and it can brings errors
	# later as player interacts with another game objects (projectiles, enemies, etc)		

func _on_shoot_timer_timeout():
	is_shooting = false
