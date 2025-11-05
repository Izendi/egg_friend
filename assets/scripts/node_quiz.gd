extends Node

var question_list: Array 
var questionData: Quiz_Question_Data
var questionTopic: String

var g_questionDifficulty: String
var g_questionTopic: String

@export var enable_warnings: bool = false

@onready var quizMenuSystem: CanvasLayer = $CanvasLayer

func outputWarning(enableWarning: bool, msg: String) -> void:
	if enable_warnings == true:
		push_warning(msg)

# Called when the node enters the scene tree for the first time.
func _ready():
	questionData = Quiz_Question_Data.new()
	
	#questionData.set_new_question_data(diff: String, catagory: String, ques: String, cor_ans: String, wrng_ans: Array)
	quizMenuSystem.setup_quiz_environment.connect(_on_setup_quiz_environment)

func _on_setup_quiz_environment() -> void:
	g_questionDifficulty = quizMenuSystem.chosenQuestionDifficulty
	g_questionTopic = quizMenuSystem.chosenQuestionTopic #Not used yet
	
	if g_questionDifficulty == "easy":
		question_list = loadQuestions("res://assets/quiz_questions/anime_easy_questions.jsonl")
	elif g_questionDifficulty == "medium":
		question_list = loadQuestions("res://assets/quiz_questions/anime_medium_questions.jsonl")
	elif g_questionDifficulty == "hard":
		question_list = loadQuestions("res://assets/quiz_questions/anime_hard_questions.jsonl")

func loadQuestions(path: String) -> Array:
	var questions_array: Array = []
	
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("could not open file: %s" % path)
		return []
	
	while not file.eof_reached():
		var line := file.get_line().strip_edges()
		if line.is_empty():
			continue
		var data = JSON.parse_string(line)
		
		if typeof(data) == TYPE_DICTIONARY:
			questions_array.append(data)
		else:
			outputWarning(enable_warnings, "Invalid JSON line: %s" % line)
	
	file.close()
	
	return questions_array 

func get_a_question_from_the_loaded_list():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
