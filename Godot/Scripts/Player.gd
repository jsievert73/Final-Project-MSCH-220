extends KinematicBody2D

var velocity = Vector2()

const up = Vector2(0, -1)
const gravity = 20
const speed = 150
const jump_speed = 500

const fireball = preload("res://Scenes/FireBall.tscn")

func _physics_process(delta):
	$AnimatedSprite.play("default")
	velocity.y += gravity
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
		if sign($ProjectilePosition.position.x) == -1:
			$ProjectilePosition.position.x *= -1
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
		if sign($ProjectilePosition.position.x) == 1:
			$ProjectilePosition.position.x *= -1
	else:
		velocity.x = 0
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = -jump_speed
	if Input.is_action_pressed("shoot"):
		var FireBall = fireball.instance()
		if sign($ProjectilePosition.position.x) == 1:
			FireBall.fireball_direction(1)
		else:
			FireBall.fireball_direction(-1)
		get_parent().add_child(FireBall)
		FireBall.position = $ProjectilePosition.global_position
	velocity = move_and_slide(velocity, up) 