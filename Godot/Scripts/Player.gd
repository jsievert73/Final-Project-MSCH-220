extends KinematicBody2D

var velocity = Vector2()

const up = Vector2(0, -1)
const gravity = 20
const speed = 150
const jump_speed = 500

func _physics_process(delta):
	$AnimatedSprite.play("default")
	velocity.y += gravity
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
	else:
		velocity.x = 0
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = -jump_speed
	velocity = move_and_slide(velocity, up) 