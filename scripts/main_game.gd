extends Node2D

@onready var player = $Player
@onready var hud = $HUD
@onready var spawner = $Spawner
@onready var game_over = $GameOver
@onready var lifeline_area = $LifelineArea

func _ready():
	player.health_changed.connect(hud.update_health)
	player.score_changed.connect(hud.update_score)
	player.died.connect(_on_player_died)
	lifeline_area.area_entered.connect(_on_lifeline_area_entered)
	hud.update_health(player.max_health)
	hud.update_score(0)

func _on_lifeline_area_entered(area):
	if area.has_signal("collected"):
		area.queue_free()
		player.take_damage()

func _on_player_died():
	spawner.stop_spawning()
	game_over.setup(player.score)
	game_over.visible = true
