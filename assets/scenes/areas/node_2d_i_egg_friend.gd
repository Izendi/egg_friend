extends Node2D

#This is my Interface egg friend class that all other egg friends will inherit from

@onready var _animated_sprite = $Node2D_animations/AnimatedSprite2D

var current_anim = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	current_anim = "idle"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if _animated_sprite.sprite_frames:
		#print("Frames resource loaded!")
	#else:
		#print("No frames assigned yet.")

func resize_and_centre_egg_friend_sprite() -> void:
	if _animated_sprite == null: #ensure this is not null
		return
	
	var size_vec: Vector2 = Vector2(1, 1)
	
	var view_size: Vector2 = get_viewport_rect().size
	#var tex_size: Vector2 = _animated_sprite.sprite_frames.get_frame_texture(current_anim, 0).get_size()
	
	#var scale_factors := view_size / tex_size
	#var s : float = max(scale_factors.x, scale_factors.y)
	_animated_sprite.scale = size_vec #Vector2(s, s)
	_animated_sprite.position = view_size * 0.5
	

func setAnimation(new_anim: String):
	if new_anim != current_anim:
		if _animated_sprite.sprite_frames.has_animation(new_anim):
			_animated_sprite.play(new_anim)
			current_anim = new_anim

func getScale() -> Vector2:
	return Vector2(1, 1)

func getCenterOffset() -> Vector2:
	return Vector2(0, 0)

func animate():
	_animated_sprite.play(current_anim)
