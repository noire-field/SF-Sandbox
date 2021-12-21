extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func UpdateHP(hp):
	GetGameGUI().SetHP(int(hp), 100)
	
func UpdateStatus(message):
	GetGameGUI().UpdateStatusText(message)

func GetGameGUI():
	return get_node("GameGUI")
