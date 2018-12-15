extends Control

func start_game():
	get_tree().change_scene("res://Scenes/Sailing.tscn")
	
func quit_game():
	get_tree().quit()
