extends Node

#this is only updated during a load, this way we can rever to previous save
@onready var loaded_save_data = {
		"save_slot_num": 1,
		"egg_friend_type": "cd",
		"egg_friend_name": "Null",
		"growth_stage": 1,
		"Days": 0,
		"Current_time_of_day": "day",
		"No_just_scoldings": 0,
		"No_unjust_scoldings": 0,
		"No_Needed_Snacks": 0,
		"No_Unneeded_Snacks": 0,
		"No_Pets": 0
		
		#"inventory": inventory,  # can be an Array or Dictionary
	}

#this in updated during playtime on the fly
@onready var current_game_data = {
		"save_slot_num": 1,
		"egg_friend_type": "cd",
		"egg_friend_name": "Null",
		"growth_stage": 1,
		"Days": 0,
		"Current_time_of_day": "day",
		"No_just_scoldings": 0,
		"No_unjust_scoldings": 0,
		"No_Needed_Snacks": 0,
		"No_Unneeded_Snacks": 0,
		"No_Pets": 0
		
		#"inventory": inventory,  # can be an Array or Dictionary
	}


#this is copied from the 
func GLOBAL_save_game_request(profileName: String, saveSlotNum: int):
	var save_path = "user://savegame_" + current_game_data["egg_friend_name"] + "/" + str(saveSlotNum) + ".json"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	#file.store_string("hello world")
	
	var json_string = JSON.stringify(current_game_data, "\t")
	file.store_string(json_string)
	
	file.close()
	print(ProjectSettings.globalize_path(save_path)) # Used for debugginf to output full path that save data was written to.


func GLOBAL_load_game_request(egg_friend_name: String, saveSlotNum: int):
	var load_path = "user://savegame_" + egg_friend_name + "/" + str(saveSlotNum) + ".json"
	
	if not FileAccess.file_exists(load_path):
		print("ERROR: No save file found.")
		return
	
	#Get save file as variable in text format in gdscript
	var file = FileAccess.open(load_path, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var result = JSON.parse_string(json_string)
	
	if typeof(result) != TYPE_DICTIONARY:
		print("ERROR: Save file is corrupted or invalid JSON.")
		return
	else:
		loaded_save_data = result
		current_game_data = loaded_save_data
	
	print(result)
