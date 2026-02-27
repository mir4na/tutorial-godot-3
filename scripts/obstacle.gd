extends Area2D

signal hit_player

@export var move_speed = 200.0
var direction = Vector2.ZERO

func setup(dir: Vector2):
	direction = dir.normalized()
	rotation = direction.angle()

func _physics_process(delta):
	position += direction * move_speed * delta
	if position.x < -100 or position.x > 1300 or position.y < -100 or position.y > 800:
		queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
		hit_player.emit()
		queue_free()
