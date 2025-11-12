extends CanvasLayer

@onready var start_menu_stack: Array = []

@onready var base_menu: Control = $Control_base_menu
@onready var options_menu: Control = $Control_options_menu
@onready var new_game_menu: Control = $Control_new_game_menu
@onready var load_game_menu: Control = $Control_load_game_menu
@onready var new_game_enter_name_menu: Control = $Control_new_game_enter_name_menu
@onready var new_game_choose_ef_type: Control = $Control_new_game_choose_ef_type

@onready var name_input_text = $Control_new_game_enter_name_menu/LineEdit_name_input_box

#sound effects:
@onready var reg_button_sound = $AudioStreamPlayer_reg_button_pressed
@onready var bad_input_sound = $AudioStreamPlayer_bad_input


var active_save_slot_num: int = 1

#signals:
signal new_egg_friend_slot(save_slot: int ,egg_friend_name: String, egg_friend_type: String)
signal load_saved_file(save_slot: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	start_menu_stack.append(base_menu)
	start_menu_stack[0].visible = true
	
	options_menu.visible = false
	new_game_menu.visible = false
	load_game_menu.visible = false
	
	# reset new game menu names
	var button_new_egg_1 = new_game_menu.get_node("Button_New_Egg_1")
	var button_new_egg_2 = new_game_menu.get_node("Button_New_Egg_2")
	var button_new_egg_3 = new_game_menu.get_node("Button_New_Egg_3")
	
	button_new_egg_1.text = GLOBAL.saveData_1_dictionary["egg_friend_name"]
	button_new_egg_2.text = GLOBAL.saveData_2_dictionary["egg_friend_name"]
	button_new_egg_3.text = GLOBAL.saveData_3_dictionary["egg_friend_name"]
	
	button_new_egg_1 = load_game_menu.get_node("Button_Load_file_1")
	button_new_egg_2 = load_game_menu.get_node("Button_Load_file_2")
	button_new_egg_3 = load_game_menu.get_node("Button_Load_file_3")
	
	button_new_egg_1.text = GLOBAL.saveData_1_dictionary["egg_friend_name"]
	button_new_egg_2.text = GLOBAL.saveData_2_dictionary["egg_friend_name"]
	button_new_egg_3.text = GLOBAL.saveData_3_dictionary["egg_friend_name"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start_menu_stack.size() == 0:
		#This should never happen, so quit the game if it does:
		print("STRANGE BEHAVIOUR: Start menu stack hit zero, closing game")
		get_tree().quit()


func play_regular_click_sound() -> void:
	reg_button_sound.play()
	

func play_bad_input_sound() -> void:
	bad_input_sound.play()

func _on_button_back_pressed():
	name_input_text.text = ""
	start_menu_stack.pop_back().visible = false
	start_menu_stack.back().visible = true
	play_regular_click_sound()


func _on_button_new_game_pressed():
	start_menu_stack.back().visible = false
	start_menu_stack.append(new_game_menu)
	start_menu_stack.back().visible = true
	play_regular_click_sound()


func _on_button_new_egg_1_pressed():
	active_save_slot_num = 1
	start_menu_stack.back().visible = false
	start_menu_stack.append(new_game_enter_name_menu)
	start_menu_stack.back().visible = true
	play_regular_click_sound()


func _on_button_new_egg_2_pressed():
	active_save_slot_num = 2
	start_menu_stack.back().visible = false
	start_menu_stack.append(new_game_enter_name_menu)
	start_menu_stack.back().visible = true
	play_regular_click_sound()


func _on_button_new_egg_3_pressed():
	active_save_slot_num = 3
	start_menu_stack.back().visible = false
	start_menu_stack.append(new_game_enter_name_menu)
	start_menu_stack.back().visible = true
	play_regular_click_sound()


func _on_button_start_game_pressed():
	print("you pressed start game with input name: " + name_input_text.text)
	
	#ensure there is no empty names, no spaces (in eng or japanese) and length is less than 11 characters!
	if name_input_text.text == "" or " " in name_input_text.text or "　" in name_input_text.text or name_input_text.text.length() > 11:
		play_bad_input_sound()
		return
	
	start_menu_stack.back().visible = false
	start_menu_stack.append(new_game_choose_ef_type)
	start_menu_stack.back().visible = true
	play_regular_click_sound()


func _on_button_quit_game_pressed():
	get_tree().quit()


func _on_button_load_file_1_pressed():
	if GLOBAL.saveData_1_dictionary["Unloaded"] == false:
		load_saved_file.emit(1)
	else:
		play_bad_input_sound()


func _on_button_load_file_2_pressed():
	if GLOBAL.saveData_2_dictionary["Unloaded"] == false:
		load_saved_file.emit(2)
	else:
		play_bad_input_sound()


func _on_button_load_file_3_pressed():
	if GLOBAL.saveData_2_dictionary["Unloaded"] == false:
		load_saved_file.emit(3)
	else:
		play_bad_input_sound()

func _on_button_load_game_pressed():
	start_menu_stack.back().visible = false
	start_menu_stack.append(load_game_menu)
	start_menu_stack.back().visible = true
	play_regular_click_sound()


func _on_button_options_pressed():
	play_bad_input_sound()


func _on_button_new_egg_sai_pressed():
	new_egg_friend_slot.emit(active_save_slot_num, name_input_text.text, "sai") # NEED TO CHANGE THIS to be dynamic


func _on_button_new_egg_debear_pressed():
	new_egg_friend_slot.emit(active_save_slot_num, name_input_text.text, "debear")


func _on_button_new_egg_snowman_pressed():
	new_egg_friend_slot.emit(active_save_slot_num, name_input_text.text, "snowman")


func _on_button_new_egg_bunny_pressed():
	new_egg_friend_slot.emit(active_save_slot_num, name_input_text.text, "bunny")


func _on_button_new_egg_shiki_pressed():
	new_egg_friend_slot.emit(active_save_slot_num, name_input_text.text, "shiki")
