extends Node

#const ef_interface = preload("res://assets/scenes/areas/node_2d_i_egg_friend.gd")
#var selected_egg_friend: ef_interface = null

const default_IdleCount = 0.0
const default_ReturnBuffer = 2.0

@onready var world: Node2D = $Node2D_world
@onready var menuSystem: CanvasLayer = $CanvasLayer

@onready var GLOBAL_game_data: Dictionary = GLOBAL.current_loaded_game_data

#This topRight_label aquisition should be updated to be clearner!
#	I should not reach down so many layers to interact with something
@onready var topRight_label: Label = $CanvasLayer/Control_info/Panel/Label

@onready var bad_input_audio: AudioStreamPlayer = $CanvasLayer/AudioStreamPlayer_bad_input
@onready var good_input_audio: AudioStreamPlayer = $CanvasLayer/AudioStreamPlayer_correct_answer

var current_level: Node2D = null

var old_egg_friend_scale: Vector2 = Vector2(1, 1)

var bool_needToResetToIdele = false
var idleCount: float = default_IdleCount #second

@export var idleReturnBuffer: float = default_ReturnBuffer

@export var egg_Friend_Starting_Scale: Vector2 = Vector2(1.0, 1.0)

var oldEvolutionPath = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# NORMAL WORK:
	
	#Connect to save game signal
	menuSystem.save_game.connect(_on_save_game_request)
	menuSystem.load_game.connect(_on_load_game_request)
	
	# Connect signals from menu sytem that will interact with egg friend
	menuSystem.pet_egg_friend.connect(_on_pet_egg_friend)
	menuSystem.scold_egg_friend.connect(_on_scold_egg_friend)
	menuSystem.feed_egg_friend.connect(_on_feed_egg_friend)
	
	menuSystem.background_changed.connect(_on_background_changed)
	menuSystem.egg_friend_changed.connect(_on_egg_friend_chosen)
	
	menuSystem.forward_time_skip.connect(_on_forward_time_jump)
	
	menuSystem.quit_game.connect(_on_quit_game)
	
	menuSystem.feed_food.connect(_on_food_fed)
	
	# Set up level loading system
	load_level("res://assets/scenes/areas/node_2d_tamagotchi_rooms.tscn", GLOBAL_game_data["Current_background"])
	
	#load egg friend:
	
	#load_egg_friend(GLOBAL_game_data["egg_friend_type"])
	#oldEvolutionPath = GLOBAL_game_data["Evolution_Path"]
	
	GLOBAL.loadSelectedEggFriend(GLOBAL_game_data["egg_friend_type"])
	

func _on_food_fed(food: String) -> void:
	if feedFood(food) == 0:
		bad_input_audio.play()
	else:
		good_input_audio.play()

func feedFood(food: String) -> int:
	if GLOBAL.current_loaded_game_data[food] == 0:
		return 0
	else:
		GLOBAL.current_loaded_game_data[food] = GLOBAL.current_loaded_game_data[food] - 1 #!!!
		#GLOBAL.selected_egg_friend.someFunction(GLOBAL.foodGrowthValuesDict[food]) # !!! You need to add a function to have egg friends respond to increased growth Values!
		return 1
	

func _on_forward_time_jump():
	GLOBAL_game_data["Days"] += 1
	GLOBAL_game_data["Days"] = int(GLOBAL_game_data["Days"])

func _on_save_game_request():
	var save_path = "user://" + str(int(GLOBAL_game_data["save_slot_num"])) + ".json"
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	#file.store_string("hello world")
	
	var json_string = JSON.stringify(GLOBAL_game_data, "\t")
	file.store_string(json_string)
	
	file.close()
	
	#store the loaded game data in the saved data slot now that it has been saved:
	GLOBAL.current_saved_game_data = GLOBAL_game_data.duplicate()
	
	print(ProjectSettings.globalize_path(save_path))

func _on_load_game_request(profileName: String, saveSlotNum: int):
	var load_path = "user://savegame_" + profileName + "_" + str(saveSlotNum) + ".json"
	
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
	
	print(result)
	

func _on_pet_egg_friend() -> void:
	print("you pet your egg friend!")
	set_current_egg_friend_animation("idle")
	need_to_reset_to_idle(default_IdleCount, default_ReturnBuffer)
	GLOBAL_game_data["No_Pets"] += 1 

func _on_scold_egg_friend() -> void:
	print("you scold your egg friend!")
	set_current_egg_friend_animation("scolded")
	need_to_reset_to_idle(default_IdleCount, default_ReturnBuffer)

func _on_feed_egg_friend() -> void:
	print("you feed your egg friend!")
	set_current_egg_friend_animation("eating")
	need_to_reset_to_idle(default_IdleCount, default_ReturnBuffer)

func _on_background_changed(backgroundName: String) -> void:
	print("background chosen is: ", backgroundName)
	load_level("res://assets/scenes/areas/node_2d_tamagotchi_rooms.tscn", backgroundName)
	GLOBAL_game_data["Current_background"] = backgroundName 
	

func _on_egg_friend_chosen(friendName: String) -> void:
	print("egg friend chosen is: ", friendName)
	load_egg_friend("res://assets/scenes/areas/node_2d_egg_friend_1.tscn") #load cd by default for now

func load_level(path: String, level_name: String) -> void:
	if current_level:
		current_level.queue_free()
		current_level = null
	
	# Load and instance the new level
	var scene: PackedScene = load(path)
	current_level = scene.instantiate()
	world.add_child(current_level)
	current_level.set_background(level_name)
	

func load_egg_friend(type_name: String) -> void:
	GLOBAL.loadSelectedEggFriend(type_name)


func set_current_egg_friend_animation(animationName: String) -> void:
	GLOBAL.selected_egg_friend.setAnimation(animationName)


func _on_button_feed_pressed():
	if current_level:
		print("Feed Button Pressed")
		set_current_egg_friend_animation("eating")


func _on_button_freeze_pressed():
	if current_level:
		print("Freeze Button Pressed")
		set_current_egg_friend_animation("sad")

func need_to_reset_to_idle(newIdleCount: float, newIdleReturnBuffer: float) -> void:
	bool_needToResetToIdele = true
	idleCount = newIdleCount
	idleReturnBuffer = newIdleReturnBuffer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bool_needToResetToIdele:
		idleCount = idleCount + delta
	
		if idleCount >= idleReturnBuffer:
			bool_needToResetToIdele = false #exit out of upper if statement in the process loop
			set_current_egg_friend_animation("idle")
			idleCount = 0.0
	
	var now = Time.get_datetime_dict_from_system()
	var h = str(now.hour).pad_zeros(2)
	var m = str(now.minute).pad_zeros(2)
	var s = str(now.second).pad_zeros(2)
	
	#SET UP TOP RIGHT DISPLAY PANEL
	topRight_label.text = "%s:%s:%s" % [h, m, s] #Real World Time
	topRight_label.text = topRight_label.text + "\n\nEgg Friend Name: " + str(GLOBAL_game_data["egg_friend_name"])
	topRight_label.text = topRight_label.text + "\nGrowth Stage: " + str(GLOBAL_game_data["growth_stage"])
	topRight_label.text = topRight_label.text + "\nRebirth Level: " + str(int(GLOBAL_game_data["rebirth_level"]))
	
	topRight_label.text = topRight_label.text + "\n\nDay: " + str(int(GLOBAL_game_data["Days"])) # In game day
	
	topRight_label.text = topRight_label.text + "\nCurrent Location: " + str(GLOBAL_game_data["Current_background"])
	topRight_label.text = topRight_label.text + "\nNo. Pets: " + str(GLOBAL_game_data["No_Pets"])
	#topRight_label.text = topRight_label.text + "\nNo. Good Scoldings: " + str(int(GLOBAL_game_data["No_just_scoldings"]))
	#topRight_label.text = topRight_label.text + "\nNo. Bad Scoldings: " + str(int(GLOBAL_game_data["No_unjust_scoldings"]))
	#topRight_label.text = topRight_label.text + "\nNo. Needed Snacks: " + str(int(GLOBAL_game_data["No_Needed_Snacks"]))
	#topRight_label.text = topRight_label.text + "\nNo. Unneeded Snacks: " + str(int(GLOBAL_game_data["No_Unneeded_Snacks"]))
	
	# !!! These two are purly for editor cutomizability for now, althought they may be used to grow the tamagotchi later
	if GLOBAL.selected_egg_friend.getScale() != GLOBAL.old_egg_friend_scale:
		GLOBAL.selected_egg_friend.resize_and_centre_egg_friend_sprite()
		GLOBAL.old_egg_friend_scale = GLOBAL.selected_egg_friend.getScale()
	
	if GLOBAL.selected_egg_friend.getCenterOffset() != GLOBAL.old_egg_friend_center_offset:
		GLOBAL.selected_egg_friend.resize_and_centre_egg_friend_sprite()
		GLOBAL.old_egg_friend_center_offset = GLOBAL.selected_egg_friend.getCenterOffset()

	# !!! Evolution used to be here

func _on_quit_game() -> void:
	get_tree().quit()
