extends Node2D

@export var collectible_scene: PackedScene
@export var obstacle_scene: PackedScene
@export var collectible_interval = 2.0
@export var obstacle_interval = 3.0
@export var arena_width = 1150.0
@export var arena_top = -30.0
@export var arena_left = -30.0
@export var arena_right = 1180.0

var is_active = true

@onready var collectible_timer = $CollectibleTimer
@onready var obstacle_timer = $ObstacleTimer

func _ready():
	collectible_timer.wait_time = collectible_interval
	collectible_timer.timeout.connect(_spawn_collectible)
	collectible_timer.start()
	obstacle_timer.wait_time = obstacle_interval
	obstacle_timer.timeout.connect(_spawn_obstacle)
	obstacle_timer.start()

func stop_spawning():
	is_active = false
	collectible_timer.stop()
	obstacle_timer.stop()

func _spawn_collectible():
	if not is_active:
		return
	var collectible = collectible_scene.instantiate()
	collectible.position = Vector2(randf_range(50, arena_width), arena_top)
	get_parent().add_child(collectible)

func _spawn_obstacle():
	if not is_active:
		return
	var obstacle = obstacle_scene.instantiate()
	var spawn_side = randi() % 3
	var target = Vector2(randf_range(100, arena_width - 100), randf_range(200, 500))

	if spawn_side == 0:
		obstacle.position = Vector2(randf_range(100, arena_width - 100), arena_top)
		obstacle.setup((target - obstacle.position))
	elif spawn_side == 1:
		obstacle.position = Vector2(arena_left, randf_range(100, 500))
		obstacle.setup((target - obstacle.position))
	else:
		obstacle.position = Vector2(arena_right, randf_range(100, 500))
		obstacle.setup((target - obstacle.position))

	get_parent().add_child(obstacle)
