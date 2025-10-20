extends Node2D

#This is my Interface egg friend class that all other egg friends will inherit from

@onready var _animated_sprite = $Node2D_Animations/AnimatedSprite2D

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

func setAnimation(new_anim: String):
	if new_anim != current_anim:
		if _animated_sprite.sprite_frames.has_animation(new_anim):
			_animated_sprite.play(new_anim)
			current_anim = new_anim

func animate():
	_animated_sprite.play(current_anim)
