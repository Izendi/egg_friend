extends CanvasLayer

var chosenQuestionTopic: String
var chosenQuestionDifficulty: String

@onready var quiz_menu_stack: Array = []

@onready var difficulty_menu: Control = $PanelContainer_question_control_menu/Control_setup_difficulty_options
@onready var main_question_menu: Control = $PanelContainer_question_control_menu/Control_question_menu
@onready var topic_menu: Control = $PanelContainer_question_control_menu/Control_setup_topic_options
@onready var correct_answer_menu: Control = $PanelContainer_question_control_menu/Control_correct_answer_menu
@onready var incorrect_answer_menu: Control = $PanelContainer_question_control_menu/Control_incorrect_answer_menu

@onready var reg_button_sound = $AudioStreamPlayer_reg_button_pressed
@onready var bad_input_sound = $AudioStreamPlayer_bad_input

@onready var question_label = $PanelContainer_question_control_menu/Control_question_menu/Panel/Label

signal setup_quiz_environment()
signal question_button_pressed(answerGiven: GLOBAL.AnswerState)
signal get_new_question()

func _ready():
	quiz_menu_stack.append(main_question_menu)
	quiz_menu_stack[0].visible = false
	quiz_menu_stack.append(difficulty_menu)
	quiz_menu_stack.back().visible = false
	quiz_menu_stack.append(topic_menu)
	quiz_menu_stack.back().visible = true
	

func display_new_question(questionData: Quiz_Question_Data) -> void:
	question_label.text = questionData.Question + "\n\n" + questionData.option_A + "\n" + questionData.option_B + "\n" + questionData.option_C + "\n" + questionData.option_D
	

func play_regular_click_sound() -> void:
	reg_button_sound.play()

func play_bad_input_sound() -> void:
	bad_input_sound.play()

func _on_button_back_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/areas/tamagotchi_global.tscn")
	


func _on_button_anime_pressed():
	play_regular_click_sound()
	chosenQuestionTopic = "anime"
	quiz_menu_stack.pop_back().visible = false
	quiz_menu_stack.back().visible = true


func _on_button_easy_pressed():
	play_regular_click_sound()
	chosenQuestionDifficulty = "easy"
	quiz_menu_stack.pop_back().visible = false
	quiz_menu_stack.back().visible = true
	setup_quiz_environment.emit()


func _on_button_medium_pressed():
	play_regular_click_sound()
	chosenQuestionDifficulty = "medium"
	quiz_menu_stack.pop_back().visible = false
	quiz_menu_stack.back().visible = true
	setup_quiz_environment.emit()


func _on_button_hard_pressed():
	play_regular_click_sound()
	chosenQuestionDifficulty = "hard"
	quiz_menu_stack.pop_back().visible = false
	quiz_menu_stack.back().visible = true
	setup_quiz_environment.emit()

func display_correct_answer_menu(questionData: Quiz_Question_Data):
	quiz_menu_stack.back().visible = false
	quiz_menu_stack.append(correct_answer_menu)
	
	var reward_amount: int = 0
	#var hard_question_prize_amount: int = 10 
	#var medium_question_prize_amount: int = 5 
	#var easy_question_prize_amount: int = 2 
	if chosenQuestionDifficulty == "easy":
		reward_amount = GLOBAL.easy_question_prize_amount
	elif chosenQuestionDifficulty == "medium":
		reward_amount = GLOBAL.medium_question_prize_amount
	else:
		reward_amount = GLOBAL.hard_question_prize_amount
	
	correct_answer_menu.get_node("Panel").get_node("Label").text = "正解!  +" + str(reward_amount) + "コイン！ \nよくできました。正しい答えは…\n\n" + questionData.correct_question_string  #正解！ よくできました。正しい答えは…
	
	quiz_menu_stack.back().visible = true

func display_incorrect_answer_menu(questionData: Quiz_Question_Data):
	quiz_menu_stack.back().visible = false
	quiz_menu_stack.append(incorrect_answer_menu)
	quiz_menu_stack.back().visible = true
	
	incorrect_answer_menu.get_node("Panel").get_node("Label").text = "不正解！  :( \n正しい答えは…\n\n" + questionData.correct_question_string  # 不正解！ 正しい答えは…
	

func _on_button_tbd_1_pressed():
	play_bad_input_sound()


func _on_button_tbs_2_pressed():
	play_bad_input_sound()



func _on_button_a_pressed():
	question_button_pressed.emit(GLOBAL.AnswerState.OPTION_A)


func _on_button_b_pressed():
	question_button_pressed.emit(GLOBAL.AnswerState.OPTION_B)


func _on_button_c_pressed():
	question_button_pressed.emit(GLOBAL.AnswerState.OPTION_C)


func _on_button_d_pressed():
	question_button_pressed.emit(GLOBAL.AnswerState.OPTION_D)


func _on_button_next_question_pressed():
	quiz_menu_stack.pop_back().visible = false
	get_new_question.emit()
	quiz_menu_stack.back().visible = true
	#need to add points based on difficulty


func _on_button_wrong_now_next_question_pressed():
	quiz_menu_stack.pop_back().visible = false
	get_new_question.emit()
	quiz_menu_stack.back().visible = true


func _on_button_geography_pressed():
	play_regular_click_sound()
	chosenQuestionTopic = "geography"
	quiz_menu_stack.pop_back().visible = false
	quiz_menu_stack.back().visible = true


func _on_button_biology_pressed():
	play_regular_click_sound()
	chosenQuestionTopic = "biology"
	quiz_menu_stack.pop_back().visible = false
	quiz_menu_stack.back().visible = true
