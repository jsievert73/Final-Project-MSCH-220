extends KinematicBody2D

const GRAVITY = 1200.0
const WALK_SPEED = 400

var velocity = Vector2()
var jump_speed=500
var jump=false

func _physics_process(delta):
    jump=false
    velocity.y += delta * GRAVITY

    if Input.is_action_pressed("ui_left"):
        velocity.x = -WALK_SPEED
    elif Input.is_action_pressed("ui_right"):
        velocity.x =  WALK_SPEED
    else:
        velocity.x = 0
    if Input.is_action_just_pressed("ui_up"):
        jump=true
    if jump and is_on_floor():
        velocity.y=-jump_speed

    move_and_slide(velocity, Vector2(0, -1))