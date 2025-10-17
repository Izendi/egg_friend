extends Node

@onready var world: Node2D = $Node2D_world
@onready var player: CharacterBody2D = $CharacterBody2D_Player
var current_level: Node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	load_level("res://assets/scenes/areas/node_2d_tamagotchi_room_1.tscn")

func load_level(path: String) -> void:
	if current_level:
		current_level.queue_free()
		current_level = null
	
	# Load and instance the new level
	var scene: PackedScene = load(path)
	current_level = scene.instantiate()
	world.add_child(current_level)
	
	var spawn = current_level.get_node_or_null("Node2D_spawnPoint")
	if spawn:
		player.global_position = spawn.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
