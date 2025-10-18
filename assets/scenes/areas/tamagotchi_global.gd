extends Node

@onready var world: Node2D = $Node2D_world
@onready var player: CharacterBody2D = $CharacterBody2D_Player
var current_level: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	load_level("res://assets/scenes/areas/node_2d_tamagotchi_rooms.tscn", 1)

func load_level(path: String, level_num: int) -> void:
	if current_level:
		current_level.queue_free()
		current_level = null
	
	# Load and instance the new level
	var scene: PackedScene = load(path)
	current_level = scene.instantiate()
	world.add_child(current_level)
	current_level.set_background(level_num)
	
	var spawn = current_level.get_node_or_null("Node2D_spawnPoint")
	if spawn:
		player.global_position = spawn.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_feed_pressed():
	if current_level:
		print("Feed Button Pressed")


func _on_button_freeze_pressed():
	if current_level:
		print("Freeze Button Pressed")


func _on_button_room_1_pressed():
	load_level("res://assets/scenes/areas/node_2d_tamagotchi_rooms.tscn", 0)


func _on_button_room_2_pressed():
	load_level("res://assets/scenes/areas/node_2d_tamagotchi_rooms.tscn", 1)


func _on_button_room_3_pressed():
	load_level("res://assets/scenes/areas/node_2d_tamagotchi_rooms.tscn", 2)
