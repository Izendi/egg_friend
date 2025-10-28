extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_save_file_1_selected() -> void:
	GLOBAL.GLOBAL_load_game_request("hello", 1) # TEST FUNC, need to be removed
