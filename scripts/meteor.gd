extends Area2D

signal hit_player
signal meteor_destroyed

@export var base_speed = 200.0
var direction = Vector2.DOWN
var health = 1
var max_health = 1
var move_speed = 200.0
var meteor_color = Color(1, 1, 1)

func _ready():
	add_to_group("meteor")
	body_entered.connect(_on_body_entered)

func setup(difficulty: float):
	health = 1 + int(difficulty * 3)
	max_health = health
	move_speed = base_speed + (difficulty * 150.0)
	
	var shade = max(0.2, 1.0 - (difficulty * 0.5))
	meteor_color = Color(shade, shade, shade)
	queue_redraw()

func _physics_process(delta):
	position += direction * move_speed * delta
	if position.y > 800:
		queue_free()

func _draw():
	draw_circle(Vector2.ZERO, 30.0, meteor_color)

func take_damage(amount: int):
	health -= amount
	meteor_color = meteor_color.lerp(Color(1, 0, 0), 0.5)
	queue_redraw()
	
	if health <= 0:
		var parent = get_parent()
		if parent.has_node("Player"):
			parent.get_node("Player").add_score(10 * max_health)
			
		var audio = $ExplosionSfx
		if audio:
			remove_child(audio)
			parent.add_child(audio)
			audio.play()
			audio.finished.connect(audio.queue_free)
			
		meteor_destroyed.emit()
		queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
		hit_player.emit()
		queue_free()
