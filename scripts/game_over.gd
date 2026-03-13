extends CanvasLayer

@onready var score_label = $CenterContainer/VBoxContainer/ScoreLabel
@onready var lose_bgm = $LoseBgm

func setup(final_score):
	score_label.text = "Final Score: " + str(final_score)
	lose_bgm.play()

func _input(event):
	if visible and event.is_action_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
