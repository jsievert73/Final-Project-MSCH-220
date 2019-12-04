extends Area2D

var speed = 200
var velocity = Vector2()
var direction = 1

func _ready():
	pass

func _physics_process(delta):
	$AnimatedSprite.play("Shoot")
	velocity.x = speed*delta*direction
	translate(velocity)

func fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
