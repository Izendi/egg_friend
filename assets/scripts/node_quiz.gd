extends Node

var question_list: Array 
var questionData: Quiz_Question_Data
var questionTopic: String

var g_questionDifficulty: String
var g_questionTopic: String

@export var enable_warnings: bool = false

@onready var quizMenuSystem: CanvasLayer = $CanvasLayer

@onready var wrong_answer_sound = $AudioStreamPlayer_wrong_answer
@onready var correct_answer_sound = $AudioStreamPlayer_correct_answer

var prize_money: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	questionData = Quiz_Question_Data.new()
	
	#questionData.set_new_question_data(diff: String, catagory: String, ques: String, cor_ans: String, wrng_ans: Array)
	quizMenuSystem.setup_quiz_environment.connect(_on_setup_quiz_environment)
	quizMenuSystem.question_button_pressed.connect(_on_question_answer_given)
	quizMenuSystem.get_new_question.connect(get_a_question_from_the_loaded_list)
	
	if GLOBAL.current_loaded_game_data["egg_friend_type"] == "sai":
		%SubViewport_ef/Sprite2D.texture = load("res://assets/scenes/egg_friends/sai/sprites/idle_1.PNG")
		%SubViewport_ef/Sprite2D.scale = Vector2(0.4, 0.4)
	elif GLOBAL.current_loaded_game_data["egg_friend_type"] == "debear":
		%SubViewport_ef/Sprite2D.texture = load("res://assets/scenes/egg_friends/debear/sprites/idle_1.PNG")
		%SubViewport_ef/Sprite2D.scale = Vector2(0.4, 0.4)
	elif GLOBAL.current_loaded_game_data["egg_friend_type"] == "snowman":
		%SubViewport_ef/Sprite2D.texture = load("res://assets/scenes/egg_friends/snowman/sprites/idle_1.PNG")
		%SubViewport_ef/Sprite2D.scale = Vector2(0.4, 0.4)
	elif GLOBAL.current_loaded_game_data["egg_friend_type"] == "bunny":
		%SubViewport_ef/Sprite2D.texture = load("res://assets/scenes/egg_friends/bunny/sprites/idle_1.png")
	elif GLOBAL.current_loaded_game_data["egg_friend_type"] == "shiki":
		%SubViewport_ef/Sprite2D.texture = load("res://assets/scenes/egg_friends/shiki/sprites/idle_1.PNG")
		%SubViewport_ef/Sprite2D.scale = Vector2(0.4, 0.4)

func get_prize_money_amount(question_difficulty) -> int:
	if question_difficulty == "hard":
		return GLOBAL.hard_question_prize_amount
	elif question_difficulty == "medium":
		return GLOBAL.medium_question_prize_amount
	else:
		return GLOBAL.easy_question_prize_amount

func play_wrong_answer_sound() -> void:
	wrong_answer_sound.play()

func play_correct_answer_sound() -> void:
	correct_answer_sound.play()

func outputWarning(enableWarning: bool, msg: String) -> void:
	if enable_warnings == true:
		push_warning(msg)

func displayCorrectAnswerScreen(question_difficulty: String) -> void:
	quizMenuSystem.display_correct_answer_menu(questionData)

func displayIncorrectAnswerScreen() -> void:
	quizMenuSystem.display_incorrect_answer_menu(questionData)


func _on_question_answer_given(answer: GLOBAL.AnswerState) -> void:
	if answer == questionData.correct_option:
		play_correct_answer_sound()
		displayCorrectAnswerScreen(questionData.df_level)
		GLOBAL.current_loaded_game_data["Coins"] += get_prize_money_amount(g_questionDifficulty)
		
	else:
		play_wrong_answer_sound()
		displayIncorrectAnswerScreen()

func _on_setup_quiz_environment() -> void:
	g_questionDifficulty = quizMenuSystem.chosenQuestionDifficulty
	g_questionTopic = quizMenuSystem.chosenQuestionTopic
	
	if g_questionTopic == "geography":
		if g_questionDifficulty == "easy":
			question_list = loadQuestions("res://assets/quiz_questions/geography_easy_questions.jsonl")
		elif g_questionDifficulty == "medium":
			question_list = loadQuestions("res://assets/quiz_questions/geography_medium_questions.jsonl")
		elif g_questionDifficulty == "hard":
			question_list = loadQuestions("res://assets/quiz_questions/geography_hard_questions.jsonl")
	elif g_questionTopic == "anime":
		if g_questionDifficulty == "easy":
			question_list = loadQuestions("res://assets/quiz_questions/anime_easy_questions.jsonl")
		elif g_questionDifficulty == "medium":
			question_list = loadQuestions("res://assets/quiz_questions/anime_medium_questions.jsonl")
		elif g_questionDifficulty == "hard":
			question_list = loadQuestions("res://assets/quiz_questions/anime_hard_questions.jsonl")
	elif g_questionTopic == "biology":
		if g_questionDifficulty == "easy":
			question_list = loadQuestions("res://assets/quiz_questions/biology_easy_questions.jsonl")
		elif g_questionDifficulty == "medium":
			question_list = loadQuestions("res://assets/quiz_questions/biology_medium_questions.jsonl")
		elif g_questionDifficulty == "hard":
			question_list = loadQuestions("res://assets/quiz_questions/biology_hard_questions.jsonl")
	else:
		question_list = loadQuestions("res://assets/quiz_questions/anime_hard_questions.jsonl") # if something goes wrong, just load hard anime questions.
	
	get_a_question_from_the_loaded_list()

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
	#print(question_list)
	var random_question_num = randi_range(0, (question_list.size() - 1))
	
	questionData.set_new_question_data(g_questionDifficulty, g_questionTopic, question_list[random_question_num]["question"], question_list[random_question_num]["correct_answer"], question_list[random_question_num]["incorrect_answers"])
	
	quizMenuSystem.display_new_question(questionData)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
