extends CanvasLayer

@onready var menu_stack: Array = []

@onready var action_menu: VBoxContainer = $Control/Action_menu
@onready var options_menu: VBoxContainer = $Control/Options_menu
@onready var sub_background_menu: VBoxContainer = $Control/Options_subBackgroundMenu
@onready var sub_egg_friend_menu: VBoxContainer = $Control/Options_subEggFriendMenu

#Signals for global manager
signal pet_egg_friend # no payload
signal feed_egg_friend # no payload
signal scold_egg_friend # no payload
signal save_game()
signal load_game(profileName: String, saveSlotNum: int)
signal background_changed(backgroundName: String)
signal egg_friend_changed(friendName: String)

signal forward_time_skip()

signal quit_game # no payload


# Called when the node enters the scene tree for the first time.
func _ready():
	menu_stack.append($Control/Main_menu)
	menu_stack[0].visible = true
	
	#Temp for debugging
	$Control/VBoxContainer.visible = false
	$Control/Action_menu.visible = false
	$Control/Options_menu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_actions_pressed():
	menu_stack.back().visible = false
	menu_stack.append(action_menu)
	menu_stack.back().visible = true


func _on_button_back_pressed():
	menu_stack.pop_back().visible = false
	menu_stack.back().visible = true


func _on_button_options_pressed():
	menu_stack.back().visible = false
	menu_stack.append(options_menu)
	menu_stack.back().visible = true


func _on_button_set_background_pressed():
	menu_stack.back().visible = false
	menu_stack.append(sub_background_menu)
	menu_stack.back().visible = true


func _on_button_set_egg_friend_pressed():
	menu_stack.back().visible = false
	menu_stack.append(sub_egg_friend_menu)
	menu_stack.back().visible = true


func _on_button_set_background_1_pressed():
	background_changed.emit("field")


func _on_button_set_background_2_pressed():
	background_changed.emit("bedroom")


func _on_button_set_background_3_pressed():
	background_changed.emit("bakery")


func _on_button_set_egg_friend_1_pressed():
	egg_friend_changed.emit("cd")


func _on_button_scold_pressed():
	scold_egg_friend.emit()


func _on_button_feed_pressed():
	feed_egg_friend.emit()


func _on_button_pet_pressed():
	pet_egg_friend.emit()


func _on_button_save_pressed():
	save_game.emit()


func _on_button_load_pressed():
	load_game.emit("testProfile", 1)


func _on_button_quit_pressed():
	quit_game.emit()


func _on_button_time_skip_pressed():
	forward_time_skip.emit()
