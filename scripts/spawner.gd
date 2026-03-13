extends Node2D

@export var obstacle_scene: PackedScene
@export var obstacle_interval = 3.0
@export var arena_width = 1150.0
@export var arena_top = -30.0

var is_active = true
var survival_time = 0.0

@onready var obstacle_timer = $ObstacleTimer

func _ready():
	obstacle_timer.wait_time = obstacle_interval
	obstacle_timer.timeout.connect(_spawn_obstacle)
	obstacle_timer.start()

func _process(delta):
	if is_active:
		survival_time += delta
		var difficulty = min(survival_time / 60.0, 1.0)
		obstacle_timer.wait_time = max(0.5, obstacle_interval - (difficulty * 2.5))

func stop_spawning():
	is_active = false
	obstacle_timer.stop()

func _spawn_obstacle():
	if not is_active:
		return
	var meteor = obstacle_scene.instantiate()
	meteor.position = Vector2(randf_range(50, arena_width - 50), arena_top)
	var difficulty = min(survival_time / 60.0, 1.0)
	if meteor.has_method("setup"):
		meteor.setup(difficulty)
	get_parent().add_child(meteor)
