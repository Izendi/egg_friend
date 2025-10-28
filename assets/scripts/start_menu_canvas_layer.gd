extends CanvasLayer

@onready var start_menu_stack: Array = []

@onready var base_menu: Control = $Control_base_menu
@onready var options_menu: Control = $Control_options_menu
@onready var new_game_menu: Control = $Control_new_game_menu
@onready var load_game_menu: Control = $Control_load_game_menu
@onready var new_game_enter_name_menu: Control = $Control_new_game_enter_name_menu

@onready var name_input_text = $Control_new_game_enter_name_menu/LineEdit_name_input_box

#sound effects:
@onready var reg_button_sound = $AudioStreamPlayer_reg_button_pressed
@onready var bad_input_sound = $AudioStreamPlayer_bad_input


var active_save_slot_num: int = 1

signal new_egg_friend_slot_1(backgroundName: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	start_menu_stack.append(base_menu)
	start_menu_stack[0].visible = true
	
	options_menu.visible = false
	new_game_menu.visible = false
	load_game_menu.visible = false


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
	
	if name_input_text.text == "":
		play_bad_input_sound()
		return
