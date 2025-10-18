extends Node

const ef_interface = preload("res://assets/scenes/areas/node_2d_i_egg_friend.gd")

@onready var world: Node2D = $Node2D_world
var current_level: Node2D = null
var selected_egg_friend: ef_interface = null

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
	

func load_egg_friend(path: String) -> void:
	if selected_egg_friend:
		selected_egg_friend.queue_free() #This queue_free func tells godot: Please remove this node (and all its children) safely at the end of the current frame.
		selected_egg_friend = null
	
	#this should point to the child type, not the parent type
	var scene: PackedScene = load(path)
	#Path to default:
	#"res://assets/scenes/areas/node_2d_egg_friend_1.tscn"
	
	var inst = scene.instantiate()
	assert(inst is ef_interface) #type safety, ensures functional polymorphism
	selected_egg_friend = inst as ef_interface
	
	#this "add_child" function call will add the node to the scene hierarchy and
	#	will cause things like @onready and the _ready function to start running
	add_child(selected_egg_friend)
	

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


func _on_button_egg_friend_1_pressed():
	load_egg_friend("res://assets/scenes/areas/node_2d_egg_friend_1.tscn")


func _on_button_egg_friend_2_pressed():
	pass # Replace with function body.


func _on_button_egg_friend_3_pressed():
	pass # Replace with function body.
