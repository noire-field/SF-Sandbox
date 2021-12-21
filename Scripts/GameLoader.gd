extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var splashScreen
var mainScreen
var findGameScreen
var gameScreen

var mainScreenLoaded = false
var showHomeScreen = true
var isInGame = false

var precacheList = [
	# Prefab
	"res://Prefabs/Weapons/Projectiles/Laser.tscn",
	"res://Prefabs/Weapons/Projectiles/Rocket.tscn",
	"res://Prefabs/Effects/Spark.tscn",
	"res://Prefabs/Effects/CircleSmoke.tscn",
	"res://Prefabs/Effects/Explosion.tscn",
	"res://Prefabs/Player.tscn",
	"res://Prefabs/MapProps/Items/HealthBox/HealthBox.tscn",
	
	# Scene
	"res://Scenes/GUI/MainScreen.tscn",
	"res://Scenes/GUI/CustomServer.tscn",
	"res://Scenes/GameScene.tscn",
	"res://Scenes/GUI/GameGUI.tscn",
	"res://Scenes/Wrapper.tscn",
	
	# Level
	#"res://pvpdm1_v3.tscn"
	"res://QuakeMap.tscn"
]

var precached = { }

# Called when the node enters the scene tree for the first time.
func _ready():
	splashScreen = preload("res://Scenes/GUI/SplashScreen.tscn").instance()
	splashScreen.name = "SplashScreen"
	
	add_child(splashScreen)
	
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("exit"):
			OnPressEscape()

func LoadGameData():
	var successLoad = true
	
	if !ClientSetting.LoadUserConfig():
		successLoad = false
		
	var t = Timer.new()
	t.set_wait_time(0.01)
	t.set_one_shot(true)
	self.add_child(t)
	
	var count = 0;
		
	for item in precacheList:
		count += 1
		splashScreen.SetLoadingResName("(" + item + ") [" + str(count) + "/" + str(precacheList.size()) + "]")
		
		t.start()
		yield(t, "timeout")
	
		precached[item] = load(item).instance()
		
	remove_child(t)
	t.queue_free()
		
	if successLoad:
		LoadHomeScreen()
		
func LoadHomeScreen():
	mainScreen = precached["res://Scenes/GUI/MainScreen.tscn"]
	mainScreen.name = "MainScreen"
	
	remove_child(splashScreen)
	add_child(mainScreen)
	
	mainScreen.JoinHome()
	
	mainScreenLoaded = true
	
	pass

func LoadGame():
	print("Load Game")
	findGameScreen = precached["res://Scenes/GUI/CustomServer.tscn"]
	findGameScreen.name = "CustomServer"
	
	mainScreen.visible = false
	showHomeScreen = false
	
	add_child(findGameScreen)

func LoadGameScene():
	print("Load GameScene...")
	
	gameScreen = precached['res://Scenes/GameScene.tscn'].duplicate()
	gameScreen.name = "GameScene"
	
	remove_child(findGameScreen)
	
	if get_node("GameScene"): remove_child(get_node("GameScene"))
	add_child(gameScreen)
	
	# Move the HomeScreen
	if get_node("MainScreen"): remove_child(get_node("MainScreen"))
	add_child(mainScreen)
	
	mainScreen.SetInGame()
	
	isInGame = true
	GlobalController.isInGame = true
	
func ReturnToServerFinder(reason):
	add_child(findGameScreen)
	
	mainScreen.visible = false
	showHomeScreen = false
	
	if Server.serverInfo['status'] >= 2:
		Server.network.close_connection()
		Server.serverInfo['status'] = 0
		gameScreen.RemoveConsole()
		print("Removed Server")
		
	findGameScreen.ErrorReset(reason)
	
	remove_child(mainScreen)
	remove_child(gameScreen)
	
	isInGame = false
	GlobalController.isInGame = false

func OnPressEscape():
	if !isInGame:
		return
	
	if !showHomeScreen:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		showHomeScreen = true
		mainScreen.visible = true
		mainScreen.get_node('Background').visible = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		showHomeScreen = false
		mainScreen.visible = false
		mainScreen.get_node('Background').visible = true
