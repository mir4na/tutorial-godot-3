extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_how_to_play_pressed():
	$HowToPlayPanel.visible = true

func _on_back_pressed():
	$HowToPlayPanel.visible = false
