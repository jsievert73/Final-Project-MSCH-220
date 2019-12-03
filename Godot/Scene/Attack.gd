extends Node2D

var new_fireball = preload("res://Scene/fireball.tscn")
var speed=400

func shoot_at_mouse(start_pos):
    var ball = new_fireball.instance()
    #get_parent().add_child(ball)
    var target_pos = get_global_mouse_position()
    ball.position = start_pos
    get_parent().add_child(ball)
    print(get_parent().name)
    ball.look_at(target_pos)
    var direction = (target_pos - start_pos).normalized()
    ball.linear_velocity = direction * speed