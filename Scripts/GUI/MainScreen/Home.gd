extends MarginContainer

onready var homeScreen = get_parent()
var gameLoader

func _ready():
	gameLoader = GlobalController.GetGameLoader()
	pass # Replace with function body.

func OnClickSetting():
	homeScreen.ShowSetting()

func OnClickQuit():
	get_tree().quit()


func OnClickFindGame():
	gameLoader.LoadGame()
