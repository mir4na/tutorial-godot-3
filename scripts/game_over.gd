extends CanvasLayer

@onready var score_label = $CenterContainer/VBoxContainer/ScoreLabel

func setup(final_score):
	score_label.text = "Final Score: " + str(final_score)

func _input(event):
	if visible and event.is_action_pressed("jump"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
