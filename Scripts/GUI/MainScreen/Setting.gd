extends MarginContainer

onready var homeScreen = get_parent()

onready var mouseSenH = get_node("MarginBox/SettingBox/MouseSenH/Slider")
onready var mouseSenV = get_node("MarginBox/SettingBox/MouseSenV/Slider")
onready var fullScreenMode = get_node("MarginBox/SettingBox/FullScreen/CheckButton")
onready var firstPersonView = get_node("MarginBox/SettingBox/FirstPersonView/CheckButton")

func _ready():
	pass # Replace with function body.
	
func RefreshConfig():
	mouseSenH.value = ClientSetting.mouseSensitivityH
	mouseSenV.value = ClientSetting.mouseSensitivityV
	
	fullScreenMode.pressed = ClientSetting.fullScreenMode
	firstPersonView.pressed = ClientSetting.firstPersonView

func OnClickReturn():
	homeScreen.ReturnHomeFrom(GlobalController.MainScreenPage.Setting)


func OnToggleFullScreenMode(button_pressed):
	if !button_pressed:
		OS.set_window_fullscreen(false)
		OS.window_size.x = 1280
		OS.window_size.y = 720
	else:
		OS.set_window_fullscreen(true)
		OS.window_size.x = 1920
		OS.window_size.y = 1080

func OnToggleFirstPersonView(button_pressed):
	pass

func OnMouseSenHChanged(value):
	pass # Replace with function body.


func OnMouseSenVChanged(value):
	pass # Replace with function body.


func OnClickSave():
	var cameraChanged = false
	
	# Mouse Sentivity
	ClientSetting.mouseSensitivityH = mouseSenH.value
	ClientSetting.mouseSensitivityV = mouseSenV.value
	
	# Display
	ClientSetting.fullScreenMode = fullScreenMode.pressed
	
	# Game
	if ClientSetting.firstPersonView != firstPersonView.pressed:
		ClientSetting.firstPersonView = firstPersonView.pressed
		cameraChanged = true
	
	if GlobalController.isInGame:
		if cameraChanged == true: ClientSetting.CheckSwitchCamera()
	
	ClientSetting.SaveSetting()
	OnClickReturn()
	

