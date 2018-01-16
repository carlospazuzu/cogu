extends KinematicBody2D

const GRAVITY = 1400
var has_sound_played = false

func _ready():
	pass
	
func _fixed_process(delta):
	if not has_sound_played:
		get_node("SamplePlayer2D").play("travel")
		has_sound_played = true
	
	move(Vector2(0, GRAVITY * delta))
	
	if is_colliding():
		get_node("AnimatedSprite").play("transform")

func _on_AnimatedSprite_finished():
	if get_node("AnimatedSprite").get_animation() == 'transform':
		get_parent().get_node("player").set_pos(Vector2(get_pos().x + 2, get_pos().y + 16))
		get_parent().get_node("player").set_hidden(false)
		get_parent().get_node("player").set_fixed_process(true)
		get_parent().get_node("player").set_process_input(true)
		get_parent().get_node("player").get_node("Sprite/AnimationPlayer").play("idle")
		get_parent().get_node("player").turn_camera_as_current()
		queue_free()
