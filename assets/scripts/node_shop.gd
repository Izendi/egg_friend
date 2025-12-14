extends Node


@export var iceCream_price: int = 3
@export var cake_price: int = 10
@export var curryRice_price: int = 25
@export var cookie_price: int = 123

@onready var shopMenuSystem: CanvasLayer = $CanvasLayer

@onready var reg_button_sound = $CanvasLayer/AudioStreamPlayer_reg_button_pressed
@onready var bad_input_sound = $CanvasLayer/AudioStreamPlayer_bad_input
@onready var item_bought_sound = $CanvasLayer/AudioStreamPlayer_correct_answer

@onready var coin_amount_label: Label = %Label_coin_wallet
@onready var current_storage_label: Label = %Label_storage

var base_coint_amount_text: String = ""

func _ready():
	shopMenuSystem.buy_button_pressed.connect(_on_buy_request)
	base_coint_amount_text = coin_amount_label.text
	coin_amount_label.text = base_coint_amount_text + " " + str(GLOBAL.current_loaded_game_data["Coins"])
	
	current_storage_label.text = \
	"ケーキ: " + str(GLOBAL.current_loaded_game_data["cake"]) + \
	"\nアイスクリーム: " + str(GLOBAL.current_loaded_game_data["iceCream"]) + \
	"\nカレーライス: " + str(GLOBAL.current_loaded_game_data["curryRice"]) + \
	"\nクッキー: " + str(GLOBAL.current_loaded_game_data["cookie"])
	
	if GLOBAL.current_loaded_game_data["egg_friend_type"] == "sai":
		%SubViewport_ef/Sprite2D.texture = load("res://assets/scenes/egg_friends/sai/sprites/idle_1.PNG")
		%SubViewport_ef/Sprite2D.scale = Vector2(0.4, 0.4)
	elif GLOBAL.current_loaded_game_data["egg_friend_type"] == "debear":
		%SubViewport_ef/Sprite2D.texture = load("res://assets/scenes/egg_friends/debear/sprites/idle_1.PNG")
		%SubViewport_ef/Sprite2D.scale = Vector2(0.4, 0.4)
	elif GLOBAL.current_loaded_game_data["egg_friend_type"] == "snowman":
		%SubViewport_ef/Sprite2D.texture = load("res://assets/scenes/egg_friends/snowman/sprites/idle_1.PNG")
		%SubViewport_ef/Sprite2D.scale = Vector2(0.4, 0.4)
	elif GLOBAL.current_loaded_game_data["egg_friend_type"] == "bunny":
		%SubViewport_ef/Sprite2D.texture = load("res://assets/scenes/egg_friends/bunny/sprites/idle_1.png")
	elif GLOBAL.current_loaded_game_data["egg_friend_type"] == "shiki":
		%SubViewport_ef/Sprite2D.texture = load("res://assets/scenes/egg_friends/shiki/sprites/idle_1.PNG")
		%SubViewport_ef/Sprite2D.scale = Vector2(0.4, 0.4)
	

func _on_buy_request(requested_item: String):
	var itemPrice = getItemPrice(requested_item)
	
	if itemPrice > GLOBAL.current_loaded_game_data["Coins"]:
		bad_input_sound.play() #not enough money to buy this item
		return
	else:
		GLOBAL.current_loaded_game_data["Coins"] = int(GLOBAL.current_loaded_game_data["Coins"] - itemPrice)
		item_bought_sound.play()
		GLOBAL.current_loaded_game_data[requested_item] += + 1
		coin_amount_label.text = base_coint_amount_text + " " + str(GLOBAL.current_loaded_game_data["Coins"])
		
		#update storage values on display:
		current_storage_label.text = \
		"ケーキ: " + str(GLOBAL.current_loaded_game_data["cake"]) + \
		"\nアイスクリーム: " + str(GLOBAL.current_loaded_game_data["iceCream"]) + \
		"\nカレーライス: " + str(GLOBAL.current_loaded_game_data["curryRice"]) + \
		"\nクッキー: " + str(GLOBAL.current_loaded_game_data["cookie"])

func getItemPrice(itemName: String) -> int:
	if itemName == "cookie":
		return cookie_price
	elif itemName == "cake":
		return cake_price
	elif itemName == "curryRice":
		return curryRice_price
	elif itemName == "iceCream":
		return iceCream_price
	else:
		return 0 #invalid item name
