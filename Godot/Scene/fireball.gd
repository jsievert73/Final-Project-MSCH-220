extends RigidBody2D

export var speed = 300.0

func _ready():
 contact_monitor = true
 set_max_contacts_reported(4)

func shoot_at_mouse(start_pos):
    var target_pos = get_global_mouse_position()
    self.global_position = start_pos
    self.look_at(target_pos)
    var direction = (target_pos - start_pos).normalized()
    self.linear_velocity = direction * speed

func _physics_process(delta):
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.is_in_group("Enemy"):
			body.Hit()
			body._on_HitBox_body_entered(self)
			self.queue_free()
		if body.is_in_group("FireBall"):
			pass
	if position.y > get_viewport_rect().end.y or position.x > get_viewport_rect().end.x:
		self.queue_free()
