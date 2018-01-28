extends KinematicBody2D

onready var player = get_parent().get_node("player")
onready var shader = get_node("AnimatedSprite").get_material()
onready var flashing_timer = get_node("Flashing Timer")
onready var animation = get_node("AnimatedSprite")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	# when player get close to the HG, it fires shooting routine
	if get_pos().distance_to(player.get_pos()) <= 200:
		shoot() # change this name
		
func shoot():
	get_node("AnimatedSprite").play("appear")

func _on_Flashing_Timer_timeout():
	shader.set_shader_param("flash", false)
	
# all collidable object MUST implement this method 
func handle_collision(body):
	if animation.get_animation() == 'default':
		if body.get_obj_ID() == 'normal shoot':
			get_node("SamplePlayer2D").play("reflect")
			body.reflect()
	elif animation.get_animation() == 'appear':
		if body.get_obj_ID() == 'normal shoot':
			take_damage()
			body.recharge()
			
func take_damage():
	get_node("SamplePlayer2D").play("enemy_damage")
	shader.set_shader_param("flash", true)
	flashing_timer.start()
	
func get_obj_ID(): return 'helmet guy'