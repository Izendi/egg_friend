extends "res://assets/scenes/areas/node_2d_i_egg_friend.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
	#Call the parents version of ready
	super._ready()
	#setAnimation("idle")
	animate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
