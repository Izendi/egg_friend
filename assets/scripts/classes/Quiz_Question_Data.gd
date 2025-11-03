# quiz_question.gd

class_name Quiz_Question_Data
extends RefCounted #lightweight, no Node behaviour

var Question: String
var uid: int
var df_level: int = 1
var prize_amount: int = 0
var option_A: String
var option_B: String
var option_C: String
var option_D: String

func _init():
	self.Question = "NA"
	self.uid = 0
	self.df_level = 0
	self.prize_amount = 0
	self.option_A = "A"
	self.option_B = "B"
	self.option_C = "C"
	self.option_D = "D"

func generate_new_question_data() -> void:
	pass
