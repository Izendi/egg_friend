extends CanvasLayer

signal buy_button_pressed(item_requested: String)

func _on_button_quit_pressed():
	get_tree().quit()


func _on_button_back_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/areas/tamagotchi_global.tscn")


func _on_button_cookie_pressed():
	buy_button_pressed.emit("cookie")


func _on_button_cake_pressed():
	buy_button_pressed.emit("cake")


func _on_button_ice_cream_pressed():
	buy_button_pressed.emit("iceCream")


func _on_button_curry_rice_pressed():
	buy_button_pressed.emit("curryRice")
