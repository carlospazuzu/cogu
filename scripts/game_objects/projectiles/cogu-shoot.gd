extends KinematicBody2D

const SPEED = 800
var direction

func _ready():
	set_fixed_process(true)
	
func set_direction(direction):
	self.direction = direction
	
func _fixed_process(delta):
	move(Vector2(SPEED * delta * direction, 0))
	get_node("AnimatedSprite").set_flip_h(true if direction == -1 else false)	
	
#	if is_out_of_bounds():
#		get_parent().get_node("player").active_bullets -= 1
#		queue_free()
	
# handle all possible collisions with the bullets
func _on_Area2D_body_enter( body ):
	if body.get_name() == 'solids':
		print('colidiu com a parede!')

#func is_out_of_bounds():	
#	return (get_pos().x > (get_parent().get_node("Camera2D").get_pos().x - ((256 * 3) / 2)) + (256 * 3) 
#			or get_pos().y < 0 
#			or get_pos().x < (get_parent().get_node("Camera2D").get_pos().x - ((256 * 3) / 2)))
	