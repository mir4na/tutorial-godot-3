extends Area2D

@export var speed = 800.0
@export var lifetime = 3.0
var direction = Vector2.UP
var damage = 1

func _ready():
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(queue_free)
	add_child(timer)
	timer.start()
	
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	position += direction * speed * delta

func _draw():
	draw_circle(Vector2.ZERO, 5.0, Color(1.0, 1.0, 0.0))

func _on_body_entered(body):
	if body.is_in_group("meteor"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("meteor"):
		if area.has_method("take_damage"):
			area.take_damage(damage)
		queue_free()
