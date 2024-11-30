extends CharacterBody2D

const GRAVITY : int = 1000
const MAX_VEL : int = 600
const JUMP_SPEED : int = -500
var jumping : bool = false
var falling : bool = false
const START_POS = Vector2(100,400)

func _ready():
	reset()

func  reset():
	falling = false
	jumping = false
	position = START_POS
	set_rotation(0)

func  _physics_process(delta):
	if jumping or falling:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VEL:
			velocity.y = MAX_VEL 
		if jumping:
			set_rotation(deg_to_rad(velocity.y * 0.03))
			$AnimatedSprite2D.play()
		elif falling:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()
		
func jump():
	velocity.y = JUMP_SPEED
