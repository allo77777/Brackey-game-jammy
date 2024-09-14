extends Control



func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/credits.tscn")
	



func _on_quit_button_pressed():
	get_tree().quit()

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
