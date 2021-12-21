extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var inputAddress
var inputName
var textResult
var buttonConnect

# Called when the node enters the scene tree for the first time.
func _ready():
	inputAddress = get_node("Control/InputAddress")
	inputName = get_node("Control/InputName")
	textResult = get_node("Control/TextResult")
	buttonConnect = get_node("Control/BtnConnect")
	
	buttonConnect.connect("button_down", self, "OnClickConnect")
	#inputAddress.text = "127.0.0.1:9999"

func OnClickConnect():
	var parsedAddress = inputAddress.text.split(':')
	
	if parsedAddress.size() != 2:
		ShowMessage("Address is invalid", -1)
		return
		
	if inputName.text.length() <= 0 or inputName.text.length() > 24:
		ShowMessage("Player Name is invalid", -1)
		return
	
	inputAddress.set("readonly", true)
	buttonConnect.set("disabled", true)
	ShowMessage("Connecting...", 0)
	
	Server.playerName = inputName.text
	Server.AttemptToConnect(parsedAddress[0], parsedAddress[1], get_instance_id())
	
func ConnectionSuccess():
	print("Connected! Loading Game Scene")
	ShowMessage("Connected! Joining in...", 1)
	get_parent().LoadGameScene()
	##get_tree().change_scene("res://Scenes/GameScene.tscn")
	
	
func ConnectionFailed():
	inputAddress.set("readonly", false)
	buttonConnect.set("disabled", false)
	
	ShowMessage("Unable to connect to server.", -1)
	
func UnableToJoin(reason):
	inputAddress.set("readonly", false)
	buttonConnect.set("disabled", false)
	
	ShowMessage(reason, -1)
	
func ErrorReset(reason):
	#inputAddress.set("readonly", false)
	#buttonConnect.set("disabled", false)
	
	ShowMessage(reason + " (Please restart game)", -1)
	
func ShowMessage(text, colorCode):
	if colorCode < 0: textResult.set("custom_colors/font_color", Color(1,0,0))
	elif colorCode > 0: textResult.set("custom_colors/font_color", Color(0,1,0))
	else: textResult.set("custom_colors/font_color", Color(1,1,1))
	
	textResult.text = text
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
