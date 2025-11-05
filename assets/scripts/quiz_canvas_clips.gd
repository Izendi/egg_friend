extends CanvasLayer

var chosenQuestionTopic: String
var chosenQuestionDifficulty: String

@onready var quiz_menu_stack: Array = []

@onready var difficulty_menu: Control = $PanelContainer_question_control_menu/Control_setup_difficulty_options
@onready var main_question_menu: Control = $PanelContainer_question_control_menu/Control_question_menu
@onready var topic_menu: Control = $PanelContainer_question_control_menu/Control_setup_topic_options

signal setup_quiz_environment()

func _ready():
	quiz_menu_stack.append(main_question_menu)
	quiz_menu_stack[0].visible = false
	quiz_menu_stack.append(topic_menu)
	quiz_menu_stack.back().visible = false
	quiz_menu_stack.append(difficulty_menu)
	quiz_menu_stack.back().visible = true

func _on_button_back_pressed():
	get_tree().change_scene_to_file("res://assets/scenes/areas/tamagotchi_global.tscn")
	

func _on_button_quit_pressed():
	get_tree().quit()


func _on_button_anime_pressed():
	chosenQuestionTopic = "anime"
	quiz_menu_stack.pop_back().visible = false
	quiz_menu_stack.back().visible = true


func _on_button_easy_pressed():
	chosenQuestionDifficulty = "easy"
	quiz_menu_stack.pop_back().visible = false
	quiz_menu_stack.back().visible = true
	setup_quiz_environment.emit()


func _on_button_medium_pressed():
	chosenQuestionDifficulty = "medium"
	quiz_menu_stack.pop_back().visible = false
	quiz_menu_stack.back().visible = true
	setup_quiz_environment.emit()


func _on_button_hard_pressed():
	chosenQuestionDifficulty = "hard"
	quiz_menu_stack.pop_back().visible = false
	quiz_menu_stack.back().visible = true
	setup_quiz_environment.emit()
