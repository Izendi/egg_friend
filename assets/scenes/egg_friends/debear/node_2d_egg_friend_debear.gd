extends "res://assets/scenes/areas/node_2d_i_egg_friend.gd"

@export var size_vec = Vector2(1, 1)
@export var center_offset = Vector2(0, 0)

@onready var ef_sprite: AnimatedSprite2D = $Node2D_animations/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#Call the parents version of ready
	super._ready()
	#setAnimation("idle")
	animate()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)

func resize_and_centre_egg_friend_sprite() -> void:
	if _animated_sprite == null: #ensure this is not null
		return
	
	var view_size: Vector2 = get_viewport_rect().size
	#var tex_size: Vector2 = _animated_sprite.sprite_frames.get_frame_texture(current_anim, 0).get_size()
	
	#var scale_factors := view_size / tex_size
	#var s : float = max(scale_factors.x, scale_factors.y)
	_animated_sprite.scale = size_vec #Vector2(s, s)
	_animated_sprite.position = view_size * 0.5
	
	#Offset from center
	_animated_sprite.position = _animated_sprite.position + center_offset

func getScale() -> Vector2:
	return size_vec

func getCenterOffset() -> Vector2:
	return center_offset

func multiplySizeVecBy(vec: Vector2) -> void:
	size_vec = size_vec * vec

func updateEggFriendForNewGrowthStage(growthStage: float) -> void:
	if growthStage >= 3.0:
		GLOBAL.current_loaded_game_data["rebirth_level"] += 1
		GLOBAL.current_loaded_game_data["growthStage"] = 1.0
	
	var level = int(GLOBAL.current_loaded_game_data["rebirth_level"])
	
	if level == 0:
		pass
	elif level == 1:
		ef_sprite.modulate = Color(1,0,0) #RED
	elif level == 2:
		ef_sprite.modulate = Color(0,1,0) #GREEN
	elif level == 3:
		ef_sprite.modulate = Color(0,0,1) #BLUE
	else: #MAX level !!!
		ef_sprite.modulate = Color(0,1,1) #TEAL
