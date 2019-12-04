extends KinematicBody2D

const gravity = 20
const speed = 30
var velocity = Vector2()
var direction = 1

func _ready():
	pass

func _physics_process(delta):
	velocity.x = speed * direction
	velocity.y += gravity
	$AnimatedSprite.play("walk")
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if is_on_wall():
		direction = direction * -1
	if direction == 1: 
		$AnimatedSprite.flip_h = false
	if direction == -1: 
		$AnimatedSprite.flip_h = true