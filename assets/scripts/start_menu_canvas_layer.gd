extends CanvasLayer

@onready var start_menu_stack: Array = []

@onready var base_menu: VBoxContainer = $Control_base_menu
@onready var options_menu: VBoxContainer = $Control_options_menu
@onready var new_game_menu: VBoxContainer = $Control_new_game_menu
@onready var load_game_menu: VBoxContainer = $Control_load_game_menu

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
