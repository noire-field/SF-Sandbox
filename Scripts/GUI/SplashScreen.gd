extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var animationPlayer = get_node("AnimationPlayer")
onready var gameLoader = get_parent()

var loadingResName = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer.play("Startup")

func StartLoading():
	print("Now Loading...")
	gameLoader.LoadGameData()
	
func SetLoadingResName(name):
	if name: loadingResName = "Loading resource... \r\n" + name + ""
	else: loadingResName = "Initializing game data..."
	
	get_node("MarginContainer/VBoxContainer/Loading").text = loadingResName

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
