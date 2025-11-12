extends Node

@onready var new_game_default_data = {
	"save_slot_num": 1,
	"egg_friend_type": "cd",
	"egg_friend_name": "empty",
	"growth_stage": float(1),
	"rebirth_level": 0,
	"Days": 0,
	"Current_background": "field",
	"No_Pets": 0,
	"No_Scoldings": 0,
	"Unloaded": true,
	"Coins": int(30),
	"cake": int(0),
	"iceCream": int(0),
	"curryRice": int(0),
	"cookie": int(0)
}

@onready var current_saved_game_data = {
	"save_slot_num": 1,
	"egg_friend_type": "cd",
	"egg_friend_name": "empty",
	"growth_stage": float(1),
	"rebirth_level": 0,
	"Days": 0,
	"Current_background": "field",
	"No_Pets": 0,
	"No_Scoldings": 0,
	"Unloaded": true,
	"Coins": int(30),
	"cake": int(0),
	"iceCream": int(0),
	"curryRice": int(0),
	"cookie": int(0)
}

@onready var current_loaded_game_data = {
	"save_slot_num": 1,
	"egg_friend_type": "cd",
	"egg_friend_name": "empty",
	"growth_stage": float(1),
	"rebirth_level": 0,
	"Days": 0,
	"Current_background": "field",
	"No_Pets": 0,
	"No_Scoldings": 0,
	"Unloaded": true,
	"Coins": int(30),
	"cake": int(0),
	"iceCream": int(0),
	"curryRice": int(0),
	"cookie": int(0)
}

var foodGrowthValuesDict = {
	"iceCream": float(0.1),
	"cake": float(0.2),
	"curryRice": float(0.4),
	"cookie": float(1.0)
}

const ef_interface = preload("res://assets/scenes/areas/node_2d_i_egg_friend.gd")
var selected_egg_friend: ef_interface = null

var old_egg_friend_scale: Vector2 = Vector2(1.0, 1.0)
var old_egg_friend_center_offset: Vector2 = Vector2(0, 0)

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
		path = "res://assets/scenes/egg_friends/CD/node_2d_egg_friend_cd_baby.tscn"
	elif type_name == "sai":
		path = "res://assets/scenes/egg_friends/sai/node_2d_egg_friend_sai.tscn"
	elif type_name == "debear":
		path = "res://assets/scenes/egg_friends/debear/node_2d_egg_friend_debear.tscn"
	elif type_name == "snowman":
		path = "res://assets/scenes/egg_friends/snowman/node_2d_egg_friend_snowman.tscn"
	elif type_name == "bunny":
		path = "res://assets/scenes/egg_friends/bunny/node_2d_egg_friend_bunny.tscn"
	elif type_name == "shiki":
		path = "res://assets/scenes/egg_friends/shiki/node_2d_egg_friend_shiki.tscn"
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
	fit_egg_friend_to_viewport()
	
	

func fit_egg_friend_to_viewport() -> void:
	if selected_egg_friend == null:
		return
	
	
	var current_loaded_scene = get_tree().current_scene
	
	print(current_loaded_scene.name)
	
	if current_loaded_scene.name == "Node_tamagotchi_global":
		var view_size: Vector2 = current_loaded_scene.get_node("Node2D_world").get_viewport_rect().size
		selected_egg_friend.resize_and_centre_egg_friend_sprite()
		old_egg_friend_scale = selected_egg_friend.getScale()
		old_egg_friend_center_offset = selected_egg_friend.getCenterOffset()
	else:
		return #do nothing
	

func getSavedGameDataInDictionaryFormat(saveDataPath: String) -> Dictionary:
	if not FileAccess.file_exists(saveDataPath):
		print("ERROR: One or more save json files are missing from the user dir, creating empty save file! Returning default empty save slot data.")
		
		var new_save_file = FileAccess.open(saveDataPath, FileAccess.WRITE)
		var new_json_string = JSON.stringify(new_game_default_data, "\t")
		new_save_file.store_string(new_json_string)
		new_save_file.close()
		
		return new_game_default_data
	
	#Get save file as variable in text format in gdscript
	var file1 = FileAccess.open(saveDataPath, FileAccess.READ)
	var json_string_1 = file1.get_as_text()
	file1.close()
	var result_dictionary = JSON.parse_string(json_string_1)
	
	if typeof(result_dictionary) != TYPE_DICTIONARY:
		print("ERROR: Save file 1 is corrupted or invalid JSON! Returning default empty save slot data.")
		return new_game_default_data
	
	return result_dictionary


func GLOBAL_save_game_request(saveSlotNum: int):
	var save_path = "user://" + str(saveSlotNum) + ".json"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	#file.store_string("hello world")
	
	if file:
		var json_string = JSON.stringify(current_loaded_game_data, "\t")
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
		current_saved_game_data = result
		current_loaded_game_data = current_saved_game_data
	
	print(result)
	return true

func GLOBAL_get_question_uid() -> int:
	return 0
