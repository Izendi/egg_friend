extends Node

@onready var startMenuSystem: CanvasLayer = $CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	startMenuSystem.new_egg_friend_slot.connect(_on_new_egg_friend_slot)
	startMenuSystem.load_saved_file.connect(_on_load_saved_file)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_new_egg_friend_slot(save_slot_num: int, egg_friend_name: String, egg_friend_type: String):
	print("function was called with name: " + egg_friend_name + " with save slot: " + str(save_slot_num))
	#create_new_save_game
	GLOBAL.loaded_save_data = GLOBAL.default_empty_save_data.duplicate() #make a deep copy
	GLOBAL.loaded_save_data["save_slot_num"] = save_slot_num
	GLOBAL.loaded_save_data["egg_friend_name"] = egg_friend_name
	GLOBAL.loaded_save_data["egg_friend_type"] = egg_friend_type
	
	GLOBAL.current_game_data = GLOBAL.loaded_save_data.duplicate() # make a deep copy for the current game data
	
	# now when we load our main scene, we can set up the character based on what is in "current_game_data" from global
	
	#load the main scene setup
	get_tree().change_scene_to_file("res://assets/scenes/areas/tamagotchi_global.tscn")

func _on_load_saved_file(save_slot: int):
	if save_slot == 1:
		GLOBAL.loaded_save_data = GLOBAL.saveData_1_dictionary.duplicate()
	elif save_slot == 2:
		GLOBAL.loaded_save_data = GLOBAL.saveData_2_dictionary.duplicate()
	elif save_slot == 3:
		GLOBAL.loaded_save_data = GLOBAL.saveData_3_dictionary.duplicate()
	else:
		print("Invalid save slot request! Doing nothing")
		return
	
	GLOBAL.current_game_data = GLOBAL.loaded_save_data.duplicate()
	
	#load the main scene and use the info in the GLOBAL autoload to setup scene as needed:
	get_tree().change_scene_to_file("res://assets/scenes/areas/tamagotchi_global.tscn")
