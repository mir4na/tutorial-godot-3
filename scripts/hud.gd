extends CanvasLayer

@onready var health_label = $HealthLabel
@onready var score_label = $ScoreLabel

func update_health(value):
	var hearts = ""
	for i in range(value):
		hearts += "❤️ "
	health_label.text = hearts.strip_edges()

func update_score(value):
	score_label.text = "Score: " + str(value)
