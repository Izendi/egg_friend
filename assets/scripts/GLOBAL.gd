extends Node

#this is only updated during a load, this way we can rever to previous save
@onready var default_empty_save_data = {
		"save_slot_num": 1,
		"egg_friend_type": "cutie",
		"egg_friend_name": "empty",
		"growth_stage": 1,
		"Days": 0,
		"Current_time_of_day": "day",
		"Current_background": "field",
		"No_just_scoldings": 0,
		"No_unjust_scoldings": 0,
		"No_Needed_Snacks": 0,
		"No_Unneeded_Snacks": 0,
		"No_Pets": 0,
		"Unloaded": true,
		"Evolution_Path": "baby",
		"Coins": 0
		#"inventory": inventory,  # can be an Array or Dictionary
	}

@onready var loaded_save_data = {
		"save_slot_num": 1,
		"egg_friend_type": "cutie",
		"egg_friend_name": "empty",
		"growth_stage": 1,
		"Days": 0,
		"Current_time_of_day": "day",
		"Current_background": "field",
		"No_just_scoldings": 0,
		"No_unjust_scoldings": 0,
		"No_Needed_Snacks": 0,
		"No_Unneeded_Snacks": 0,
		"No_Pets": 0,
		"Unloaded": true,
		"Evolution_Path": "baby",
		"Coins": 0
		#"inventory": inventory,  # can be an Array or Dictionary
	}

#this in updated during playtime on the fly
@onready var current_game_data = {
		"save_slot_num": 1,
		"egg_friend_type": "cutie",
		"egg_friend_name": "empty",
		"growth_stage": 1,
		"Days": 0,
		"Current_time_of_day": "day",
		"Current_background": "field",
		"No_just_scoldings": 0,
		"No_unjust_scoldings": 0,
		"No_Needed_Snacks": 0,
		"No_Unneeded_Snacks": 0,
		"No_Pets": 0,
		"Unloaded": true,
		"Evolution_Path": "baby",
		"Coins": 0
		#"inventory": inventory,  # can be an Array or Dictionary
	}

const ef_interface = preload("res://assets/scenes/areas/node_2d_i_egg_friend.gd")
var selected_egg_friend: ef_interface = null

var current_egg_Friend_Scale: Vector2 = Vector2(1.0, 1.0)

@onready var save_slot_name_1 = "empty egg 1"
@onready var save_slot_name_2 = "empty egg 2"
@onready var save_slot_name_3 = "empty egg 3"

var saveData_1_dictionary: Dictionary
var saveData_2_dictionary: Dictionary
var saveData_3_dictionary: Dictionary

var hard_question_prize_amount: int = 10 
var medium_question_prize_amount: int = 5 
var easy_question_prize_amount: int = 2 

enum AnswerState {OPTION_A, OPTION_B, OPTION_C, OPTION_D}


func _ready():
	var load_slot_path_1 = "user://1.json"
	var load_slot_path_2 = "user://2.json"
	var load_slot_path_3 = "user://3.json"
	
	saveData_1_dictionary = getSavedGameDataInDictionaryFormat(load_slot_path_1)
	saveData_2_dictionary = getSavedGameDataInDictionaryFormat(load_slot_path_2)
	saveData_3_dictionary = getSavedGameDataInDictionaryFormat(load_slot_path_3)
	

func loadSelectedEggFriend(type_name: String) -> void:
	var path: String = ""
	if type_name == "cd":
		if current_game_data["Evolution_Path"] == "baby":
			path = "res://assets/scenes/egg_friends/CD/node_2d_egg_friend_cd_baby.tscn"
		elif current_game_data["Evolution_Path"] == "bad_teen":
			path = "res://assets/scenes/egg_friends/CD/node_2d_egg_friend_cd_bad_teen.tscn"
		elif current_game_data["Evolution_Path"] == "good_teen":
			path = "res://assets/scenes/egg_friends/CD/node_2d_egg_friend_cd_good_teen.tscn"
		elif current_game_data["Evolution_Path"] == "bad_adult":
			path = "res://assets/scenes/egg_friends/CD/node_2d_egg_friend_cd_bad_adult.tscn"
		elif current_game_data["Evolution_Path"] == "good_adult":
			path = "res://assets/scenes/egg_friends/CD/node_2d_egg_friend_cd_good_adult.tscn"
	elif type_name == "cutie":
		if current_game_data["Evolution_Path"] == "baby":
			path = "res://assets/scenes/egg_friends/Cutie/node_2d_egg_friend_cutie_teen_good.tscn"
	else:
		path = "res://assets/scenes/egg_friends/CD/node_2d_egg_friend_cd_baby.tscn" # cd is the default
		print("invalid name, using default egg friend (cd)")
		
		
	if GLOBAL.selected_egg_friend:
		GLOBAL.selected_egg_friend.queue_free() #This queue_free func tells godot: Please remove this node (and all its children) safely at the end of the current frame.
		GLOBAL.selected_egg_friend = null
	
	#this should point to the child type, not the parent type
	var scene: PackedScene = load(path)
	#Path to default:
	#"res://assets/scenes/areas/node_2d_egg_friend_1.tscn"
	
	var inst = scene.instantiate()
	assert(inst is ef_interface) #type safety, ensures functional polymorphism
	GLOBAL.selected_egg_friend = inst as ef_interface
	#assert(inst is ef_interface)
	
	#this "add_child" function call will add the node to the scene hierarchy and
	#	will cause things like @onready and the _ready function to start running
	get_tree().current_scene.add_child(selected_egg_friend)
	fit_egg_friend_to_viewport(current_egg_Friend_Scale)
	
	

func fit_egg_friend_to_viewport(scale_vector: Vector2) -> void:
	if selected_egg_friend == null:
		return
	
	
	var current_loaded_scene = get_tree().current_scene
	
	print(current_loaded_scene.name)
	
	if current_loaded_scene.name == "Node_tamagotchi_global":
		var view_size: Vector2 = current_loaded_scene.get_node("Node2D_world").get_viewport_rect().size
		selected_egg_friend.resize_and_centre_egg_friend_sprite(scale_vector)
	else:
		return #do nothing
	

func getSavedGameDataInDictionaryFormat(saveDataPath: String) -> Dictionary:
	if not FileAccess.file_exists(saveDataPath):
		print("ERROR: One or more save json files are missing from the user dir, creating empty save file! Returning default empty save slot data.")
		
		var new_save_file = FileAccess.open(saveDataPath, FileAccess.WRITE)
		var new_json_string = JSON.stringify(default_empty_save_data, "\t")
		new_save_file.store_string(new_json_string)
		new_save_file.close()
		
		return default_empty_save_data
	
	#Get save file as variable in text format in gdscript
	var file1 = FileAccess.open(saveDataPath, FileAccess.READ)
	var json_string_1 = file1.get_as_text()
	file1.close()
	var result_dictionary = JSON.parse_string(json_string_1)
	
	if typeof(result_dictionary) != TYPE_DICTIONARY:
		print("ERROR: Save file 1 is corrupted or invalid JSON! Returning default empty save slot data.")
		return default_empty_save_data
	
	return result_dictionary

#this is copied from the 
func GLOBAL_save_game_request(saveSlotNum: int):
	var save_path = "user://" + str(saveSlotNum) + ".json"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	#file.store_string("hello world")
	
	if file:
		var json_string = JSON.stringify(current_game_data, "\t")
		file.store_string(json_string)
	else:
		print("unable to open save data in GLOBAL script")
	
	file.close()
	print(ProjectSettings.globalize_path(save_path)) # Used for debugginf to output full path that save data was written to.


func GLOBAL_load_game_request(egg_friend_name: String, saveSlotNum: int) -> bool:
	var load_path = "user://" + str(saveSlotNum) + ".json"
	
	if not FileAccess.file_exists(load_path):
		print("ERROR: No save file found.")
		return false
	
	#Get save file as variable in text format in gdscript
	var file = FileAccess.open(load_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(json_string)
	
	if typeof(result) != TYPE_DICTIONARY:
		print("ERROR: Save file is corrupted or invalid JSON.")
		return false
	else:
		loaded_save_data = result
		current_game_data = loaded_save_data
	
	print(result)
	return true

func GLOBAL_get_question_uid() -> int:
	return 0
