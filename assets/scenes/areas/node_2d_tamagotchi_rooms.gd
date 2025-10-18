extends Node2D

@onready var bg_sprite: Sprite2D = $"Sprite2D_background"

@export var backgrounds: Array[Texture2D] = []
@export var background_names: Array[StringName] = []

func _ready():
	if backgrounds.size() > 0:
		set_background(1)
		
func set_background(idx: int) -> void:
	#If invalid, do nothing
	if idx < 0 or idx >= backgrounds.size():
		return
	
	bg_sprite.texture = backgrounds[idx]
	fit_background_to_viewport()

func fit_background_to_viewport() -> void:
	if bg_sprite.texture == null:
		return
	
	var view_size: Vector2 = get_viewport_rect().size
	var tex_size: Vector2 = bg_sprite.texture.get_size()
	
	if tex_size.x == 0 or tex_size.y == 0:
		return #do nothing is either dimension is 0
	
	# Pick the bigest scale factor and scale by that, will create some zoom in
	#	if ratio does not match.
	var scale_factors := view_size / tex_size
	var s : float = max(scale_factors.x, scale_factors.y)
	bg_sprite.scale = Vector2(s, s)
	bg_sprite.position = view_size * 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
