extends CharacterBody2D

signal health_changed(value)
signal score_changed(value)
signal died

@export var gravity = 800.0
@export var walk_speed = 500.0
@export var jump_speed = -400.0
@export var max_jumps = 2
@export var dash_speed = 600.0
@export var dash_duration = 0.2
@export var dash_cooldown = 0.5
@export var double_tap_threshold = 0.3
@export var crouch_speed = 80.0
@export var max_health = 3
@export var invincibility_duration = 1.0
@export var projectile_scene: PackedScene

var jump_count = 0
var is_dashing = false
var is_dash_on_cooldown = false
var is_crouching = false
var is_invincible = false
var last_left_tap_time = -1.0
var last_right_tap_time = -1.0
var health = 3
var score = 0
var aim_angle = -PI / 2.0
var aim_direction = Vector2.UP

@onready var animation = $AnimatedSprite2D
@onready var bot_collision = $CollisionShapeBot
@onready var top_collision = $CollisionShapeTop
@onready var dash_timer = $DashTimer
@onready var dash_cooldown_timer = $DashCooldownTimer
@onready var invincibility_timer = $InvincibilityTimer

func _process(delta):
	var rotation_input = Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")
	if rotation_input != 0:
		aim_angle += rotation_input * 5.0 * delta
		aim_angle = clamp(aim_angle, -PI, 0)
		aim_direction = Vector2(cos(aim_angle), sin(aim_angle))
	queue_redraw()

func _draw():
	draw_line(Vector2.ZERO, aim_direction * 300, Color(1, 0, 0, 1), 2.0)

func _ready():
	health = max_health
	dash_timer.wait_time = dash_duration
	dash_timer.one_shot = true
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	dash_cooldown_timer.wait_time = dash_cooldown
	dash_cooldown_timer.one_shot = true
	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timeout)
	invincibility_timer.wait_time = invincibility_duration
	invincibility_timer.one_shot = true
	invincibility_timer.timeout.connect(_on_invincibility_timeout)

func _physics_process(delta):
	_apply_gravity(delta)
	_handle_jump()
	_handle_dash()
	_handle_crouch()
	_handle_movement()
	_handle_shooting()
	_update_animation()
	move_and_slide()

func _apply_gravity(delta):
	velocity.y += delta * gravity

func _handle_jump():
	if is_on_floor():
		jump_count = 0

	if Input.is_action_just_pressed("jump") and jump_count < max_jumps:
		$JumpSfx.play()
		velocity.y = jump_speed
		jump_count += 1

func _handle_dash():
	if is_dashing or is_dash_on_cooldown:
		return

	var current_time = Time.get_ticks_msec() / 1000.0

	if Input.is_action_just_pressed("move_left"):
		if current_time - last_left_tap_time <= double_tap_threshold:
			_start_dash(Vector2.LEFT)
		last_left_tap_time = current_time

	if Input.is_action_just_pressed("move_right"):
		if current_time - last_right_tap_time <= double_tap_threshold:
			_start_dash(Vector2.RIGHT)
		last_right_tap_time = current_time

func _start_dash(direction: Vector2):
	is_dashing = true
	velocity.x = direction.x * dash_speed
	velocity.y = 0
	dash_timer.start()

func _on_dash_timer_timeout():
	is_dashing = false
	is_dash_on_cooldown = true
	dash_cooldown_timer.start()

func _on_dash_cooldown_timeout():
	is_dash_on_cooldown = false

func _handle_crouch():
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		top_collision.disabled = true
	else:
		is_crouching = false
		top_collision.disabled = false

func _handle_movement():
	if is_dashing:
		return

	var speed = crouch_speed if is_crouching else walk_speed

	if Input.is_action_pressed("move_left"):
		velocity.x = -speed
		animation.flip_h = true
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
		animation.flip_h = false
	else:
		velocity.x = 0

func _handle_shooting():
	if Input.is_action_just_pressed("shoot") and projectile_scene:
		var proj = projectile_scene.instantiate()
		proj.position = global_position
		proj.direction = aim_direction
		get_parent().add_child(proj)

func _update_animation():
	if is_dashing:
		animation.play("slide")
		return

	if is_crouching:
		animation.play("crouch")
		return

	if not is_on_floor():
		if velocity.y < 0:
			animation.play("jump")
		else:
			animation.play("fall")
		return

	if velocity.x != 0:
		animation.play("run")
	else:
		animation.play("idle")

func take_damage():
	if is_invincible:
		return
	health -= 1
	health_changed.emit(health)
	is_invincible = true
	invincibility_timer.start()
	_play_hit_flash()
	if health <= 0:
		died.emit()

func _play_hit_flash():
	var sprite_material = animation.material
	if sprite_material:
		var tween = create_tween()
		tween.tween_property(sprite_material, "shader_parameter/flash_intensity", 1.0, 0.05)
		tween.tween_property(sprite_material, "shader_parameter/flash_intensity", 0.0, 0.15)
		var blink_tween = create_tween()
		blink_tween.set_loops(5)
		blink_tween.tween_property(animation, "modulate:a", 0.3, 0.1)
		blink_tween.tween_property(animation, "modulate:a", 1.0, 0.1)

func _on_invincibility_timeout():
	is_invincible = false
	animation.modulate.a = 1.0

func add_score(amount):
	score += amount
	score_changed.emit(score)
