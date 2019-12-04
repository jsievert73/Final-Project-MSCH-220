extends Area2D

export(String, FILE, "*.tscn") var next_scene

func _ready():
	$AnimatedSprite.play("Goal")

func _on_Goal_body_entered(body):
	if "Player" in body.name:
 		get_tree().change_scene(next_scene)