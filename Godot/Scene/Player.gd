extends KinematicBody2D

const GRAVITY = 1200.0
const WALK_SPEED = 400

var velocity = Vector2()
var jump_speed=500
var jump=false

var timer=null
var bullet_delay=1
var can_shoot=true
var life=100

var _color=0.0
var _color_decay=1
var _normal_color			#color change
var _decay_rate=0.0
var trauma_color=Color(1,0,0)

func _ready():
    _normal_color= Color(1,1,1)
    set_process_input(true)
    timer=Timer.new()
    timer.set_one_shot(true)
    timer.set_wait_time(bullet_delay)
    timer.connect("timeout",self,"on_timeout_complete")
    add_child(timer)
    $GUI/life.value=life
    $GUI/Attack1Cooldown.value=bullet_delay

func on_timeout_complete():
	can_shoot=true

func _physics_process(delta):
    jump=false
    velocity.y += delta * GRAVITY

    if Input.is_action_pressed("ui_left"):
        velocity.x = -WALK_SPEED
        $Sprite.flip_h = true
    elif Input.is_action_pressed("ui_right"):
        velocity.x =  WALK_SPEED
        $Sprite.flip_h = false
    else:
        velocity.x = 0
    if Input.is_action_just_pressed("ui_up"):
        jump=true
    if jump and is_on_floor():
        velocity.y=-jump_speed
    if Input.is_action_just_pressed("Attack") and can_shoot:
            var projectile = preload("res://Scene/fireball.tscn").instance()
            get_parent().add_child(projectile)
            projectile.shoot_at_mouse(self.global_position)
            can_shoot=false
            timer.start()
            
    $GUI/Attack1Cooldown.value=timer.get_time_left()
    if life<=0:
        velocity.x=0
        jump=false
        can_shoot=false
        if Input.is_action_just_pressed("heal"):
            life+=10

    move_and_slide(velocity, Vector2(0, -1))
func _process(delta):
    if _color>0:
        _decay_color(delta)
        _apply_color()
    if _color ==0 and $Sprite.modulate != _normal_color:
        $Sprite.modulate=_normal_color
func add_color(amount):
	_color =amount
func _apply_color():
	var a= min(1,_color)
	$Sprite.modulate=_normal_color.linear_interpolate(trauma_color,a)
func _decay_color(delta):
	var change=_color_decay*delta
	_color=max(_color-change,0)
func Hit():
	add_color(1.0)


func _on_HitBox_body_entered(body):
	if body.is_in_group("Enemy"):
		var collision_point=global_position-body.global_position
		velocity.x=sign(collision_point.x)*(1200*2)
		velocity.y=-350
		velocity=move_and_slide(velocity,Vector2(0,-1))
		life-=10
		$GUI/life.value=life
	if body.is_in_group("EnemyFireBall"):
		var collision_point=global_position-body.global_position
		velocity.x=sign(collision_point.x)*(1200*2)
		velocity.y=-350
		velocity=move_and_slide(velocity,Vector2(0,-1))
		life-=15
		$GUI/life.value=life