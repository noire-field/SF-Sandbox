extends Node


enum MainScreenPage { Home, Setting }

var isInGame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func GetGameLoader():
	return get_node("/root/GameLoader")

func GetGameScene():
	return get_node("/root/GameLoader/GameScene")
