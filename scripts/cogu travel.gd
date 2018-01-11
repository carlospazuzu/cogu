extends KinematicBody2D

const GRAVITY = 1400

func _ready():
	pass
	
func _fixed_process(delta):
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
		queue_free()
