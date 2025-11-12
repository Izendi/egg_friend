# quiz_question.gd

class_name Quiz_Question_Data
extends RefCounted #lightweight, no Node behaviour

var Question: String
var question_catagory: String
var df_level: String = "NA"
var prize_amount: int = 0
var option_A: String
var option_B: String
var option_C: String
var option_D: String
var correct_option: int
var correct_question_string: String

#Dictionary Structure:
#	difficulty (string): "easy" / "medium" / "hard"
#	catagory (string): "Entertainment: Japanese Anime &amp; Manga"
#	question (string): "In what year did the manga \"Ping Pong\" begin serialization?"
#	correct_answer (string): "1996"
#	incorrect_answers (array of strings): ["2014", "2010", "2003"]

func _init():
	self.Question = "NA"
	self.df_level = "NA"
	self.prize_amount = 0
	self.option_A = "A"
	self.option_B = "B"
	self.option_C = "C"
	self.option_D = "D"
	self.question_catagory = "NA"
	self.correct_option = 5
	self.correct_question_string = "NA"

# GLOBAL_hard_question_prize_amount

func set_new_question_data(diff: String, catagory: String, ques: String, cor_ans: String, wrng_ans: Array) -> void:
	self.df_level = diff
	self.question_catagory = catagory
	
	if self.df_level == "easy":
		self.prize_amount = GLOBAL.easy_question_prize_amount
	if self.df_level == "medium":
		self.prize_amount = GLOBAL.medium_question_prize_amount
	if self.df_level == "hard":
		self.prize_amount = GLOBAL.hard_question_prize_amount
	
	self.Question = ques
	
	var r_num = randi_range(1, 4)
	
	self.correct_question_string = cor_ans 
	
	if r_num == 1:
		self.correct_option = GLOBAL.AnswerState.OPTION_A
		self.option_A = "A - " + cor_ans
		self.option_B = "B - " + wrng_ans[0]
		self.option_C = "C - " + wrng_ans[1]
		self.option_D = "D - " + wrng_ans[2]
	elif r_num == 2:
		self.correct_option = GLOBAL.AnswerState.OPTION_B
		self.option_A = "A - " + wrng_ans[2]
		self.option_B = "B - " + cor_ans
		self.option_C = "C - " + wrng_ans[0]
		self.option_D = "D - " + wrng_ans[1]
	elif r_num == 3:
		self.correct_option = GLOBAL.AnswerState.OPTION_C
		self.option_A = "A - " + wrng_ans[0]
		self.option_B = "B - " + wrng_ans[2]
		self.option_C = "C - " + cor_ans
		self.option_D = "D - " + wrng_ans[1]
	elif r_num == 4:
		self.correct_option = GLOBAL.AnswerState.OPTION_D
		self.option_A = "A - " + wrng_ans[1]
		self.option_B = "B - " + wrng_ans[0]
		self.option_C = "C - " + wrng_ans[2]
		self.option_D = "D - " + cor_ans
