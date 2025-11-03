extends Node

var questionData: Quiz_Question_Data

# Called when the node enters the scene tree for the first time.
func _ready():
	questionData = Quiz_Question_Data.new()
	questionData.generate_new_question_data()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
