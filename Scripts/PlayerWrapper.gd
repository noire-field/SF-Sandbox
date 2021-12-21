extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var cameraRoot1st = get_node("CameraRoot1st")
onready var cameraRoot3rd = get_node("CameraRoot3rd")

var currentCameraRoot = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ClientSetting.connect('UserChangeCamera', self, 'OnUserChangeCamera')
	Server.get_node("PlayerController/Weapon").connect('AddPunchAngle', self, 'AddPunchAngle')
	
	MarkCurrentCamera()
	
func MakeCameraCurrent():
	currentCameraRoot.get_node("H/V/Camera").make_current()

func MarkCurrentCamera():
	if ClientSetting.firstPersonView == true: currentCameraRoot = cameraRoot1st
	else: currentCameraRoot = cameraRoot3rd
	
func OnUserChangeCamera(toFPS):
	var current = get_viewport().get_camera()
	
	MarkCurrentCamera()
	
	# Make sure it's not other cameras beside 1st and 3rd
	if current == cameraRoot1st.get_node("H/V/Camera") or current == cameraRoot3rd.get_node("H/V/Camera"):
		MakeCameraCurrent()
		
func AddPunchAngle(vector):
	currentCameraRoot.AddPunchAngle(vector)
