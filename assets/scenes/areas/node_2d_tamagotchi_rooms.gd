extends Node2D

@onready var bg_sprite: Sprite2D = $"Sprite2D_background"

@export var backgrounds: Array[Texture2D] = []
@export var background_names: Array[StringName] = []

var backgrounds_map: Dictionary[String, Texture2D]

func _ready():
	if backgrounds.size() > 0:
		set_background("field")
		
		backgrounds_map["bedroom"] = backgrounds[0]
		backgrounds_map["bakery"] = backgrounds[1]
		backgrounds_map["field"] = backgrounds[2]
		
func set_background(name: String) -> void:
	#If invalid, do nothing
	if not backgrounds_map.has(name):
		return
	
	bg_sprite.texture = backgrounds_map[name]
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
