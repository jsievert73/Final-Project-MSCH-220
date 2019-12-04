extends Node2D
#DOES NOT WORK
var spawn=preload("res://Scene/Enemy.tscn").instance()
var count=5
var timer=null
var spawn_delay=1
var can_spawn=true

func _ready():
	timer=Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(spawn_delay)
	timer.connect("timeout",self,"on_timeout_complete")
	add_child(timer)

func on_timeout_complete():
	can_spawn=true

func _physics_process(delta):
	if can_spawn:
		get_parent().add_child(spawn)
		can_spawn=false
		timer.start()