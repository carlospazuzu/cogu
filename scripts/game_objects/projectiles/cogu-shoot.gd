extends KinematicBody2D

const SPEED = 800
var ydesl = 0
var direction

onready var camera = get_parent().get_node("Camera2D")

func _ready():
	set_fixed_process(true)
	
func set_direction(direction): self.direction = direction
func get_direction(): return self.direction
func set_ydesl(direction): self.ydesl = ydesl
func get_ydesl(): return self.ydesl

func _fixed_process(delta):
	move(Vector2(SPEED * delta * direction, ydesl * delta))
	get_node("AnimatedSprite").set_flip_h(true if direction == -1 else false)	
	
	if is_out_of_bounds():
		recharge()
	
# handle all possible collisions with the bullets
func _on_Area2D_body_enter( body ):
	if body.get_name() == 'solids':
		print('colidiu com a parede!')

func _on_Area2D_area_enter( area ):
	area.get_parent().handle_collision(self)

func is_out_of_bounds():
	return (get_pos().x > (camera.get_pos().x + (256 * 3)) # because the screen is scaled 3x
			or get_pos().y < camera.get_pos().y 
			or get_pos().x < camera.get_pos().x)

# kill current bullet instance and recharge player available bullets
func recharge():
	get_parent().get_node("player").active_bullets -= 1
	queue_free()

func reflect():
	ydesl = -SPEED
	set_direction(-direction)

func get_obj_ID(): return 'normal shoot'
