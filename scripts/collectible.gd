extends Area2D

signal collected

@export var fall_speed = 150.0

func _physics_process(delta):
	position.y += fall_speed * delta
	rotation += delta * 2.0

func _on_body_entered(body):
	if body.has_method("add_score"):
		body.add_score(1)
		collected.emit()
		queue_free()
