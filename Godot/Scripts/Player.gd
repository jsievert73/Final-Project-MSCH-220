extends KinematicBody2D

var velocity = Vector2()


const speed = 150

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
	elif Input.is_action_pressed("move_left"):
		velocity.x = speed
	else:
		velocity.x = 0
	velocity = move_and_slide(velocity) 