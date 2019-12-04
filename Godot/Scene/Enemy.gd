extends KinematicBody2D

onready var Player = get_parent().get_node("Player")
var vel = Vector2(0, 0)
var grav = 1800
var max_grav = 3000
var react_time = 400
var dir = 0
var next_dir = 0
var next_dir_time = 0
var next_jump_time = -1
var target_player_dist = 10
var eye_reach = 90
var vision = 600
var life=100

var timer=null
var bullet_delay=2
var can_shoot=true

var _color=0.0
var _color_decay=1
var _normal_color			#color change
var _decay_rate=0.0
var trauma_color=Color(1,0,0)

func _ready():
	set_process(true)
	_normal_color= Color(1,1,1)		#color change
	$Sprite/life.value=life
	timer=Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(bullet_delay)
	timer.connect("timeout",self,"on_timeout_complete")
	add_child(timer)
func on_timeout_complete():
	can_shoot=true
func set_dir(target_dir):
	if next_dir != target_dir:
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time
func sees_player():
	var eye_center = get_global_position()
	var eye_top = eye_center + Vector2(0, -eye_reach)
	var eye_left = eye_center + Vector2(-eye_reach, 0)
	var eye_right = eye_center + Vector2(eye_reach, 0)
	var player_pos = Player.get_global_position()
	var player_extents = Player.get_node("CollisionShape2D").shape.extents - Vector2(1, 1)
	var top_left = player_pos + Vector2(-player_extents.x, -player_extents.y)
	var top_right = player_pos + Vector2(player_extents.x, -player_extents.y)
	var bottom_left = player_pos + Vector2(-player_extents.x, player_extents.y)
	var bottom_right = player_pos + Vector2(player_extents.x, player_extents.y)
	var space_state = get_world_2d().direct_space_state
	for eye in [eye_center, eye_top, eye_left, eye_right]:
		for corner in [top_left, top_right, bottom_left, bottom_right]:
			if (corner - eye).length() > vision:
				continue
			var collision = space_state.intersect_ray(eye, corner, [], 1) # collision mask = sum of 2^(collision layers) - e.g 2^0 + 2^3 = 9
			if collision and collision.collider.name == "Player":
				return true
	return false
func _process(delta):
	if life==0:
		self.queue_free()
	if Player.position.x < position.x - target_player_dist and sees_player():
		set_dir(-1)
	elif Player.position.x > position.x + target_player_dist and sees_player():
		set_dir(1)
	else:
		set_dir(0)
	if OS.get_ticks_msec() > next_dir_time:
		dir = next_dir
	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor():
		if Player.position.y < position.y - 64 and sees_player():
			vel.y = -600
		next_jump_time = -1
	vel.x = dir * 100
	if Player.position.y < position.y - 64 and next_jump_time == -1 and sees_player():
		next_jump_time = OS.get_ticks_msec() + react_time
	vel.y += grav * delta;
	if vel.y > max_grav:
		vel.y = max_grav
	if is_on_floor() and vel.y > 0:
		vel.y = 0
	vel = move_and_slide(vel, Vector2(0, -1))
	if sees_player() and can_shoot:
		var projectile = preload("res://Scene/EFireBall.tscn").instance()
		get_parent().add_child(projectile)
		projectile.shoot_at_Player(self.global_position)
		can_shoot=false
		timer.start()
	
#color change----
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
	if body.is_in_group("FireBall"):
		var collision_point=global_position-body.global_position
		vel.x=sign(collision_point.x)*(1200*2)
		vel.y=-350
		vel=move_and_slide(vel,Vector2(0,-1))
		life-=20
		$Sprite/life.value=life
	if body.is_in_group("Player"):
		body.Hit()
