extends CanvasLayer

func _on_button_quit_pressed():
	get_tree().quit()


func _on_button_back_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/areas/tamagotchi_global.tscn")
