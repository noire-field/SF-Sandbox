extends Spatial

var cameraRootH = 0
var cameraRootV = 0
var cameraMaxV = 75
var cameraMinV = -75
var senH = 0.2
var senV = 0.2
var accelH = 10
var accelV = 10

var player
onready var thisCamera = $H/V/Camera as Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	player = get_parent().get_parent()
	$H/V/Camera.add_exception(player)
	
func _input(event):
	if event is InputEventMouseMotion:
		cameraRootH += event.relative.x * ClientSetting.mouseSensitivityH #senH
		cameraRootV += event.relative.y * ClientSetting.mouseSensitivityV #senV
		
func _physics_process(delta):
	cameraRootV = clamp(cameraRootV, cameraMinV, cameraMaxV)
	
	#$H.rotation_degrees.y = lerp($H.rotation_degrees.y, -cameraRootH, delta * accelH)
	$H/V.rotation_degrees.x = lerp($H/V.rotation_degrees.x, -cameraRootV, delta * accelV)
	
	var camRot = thisCamera.rotation_degrees
	
	if camRot.x > 0.0: camRot.x = clamp(camRot.x - 0.1, 0.0, 99.0)
	elif camRot.x < 0.0: camRot.x = clamp(camRot.x + 0.1, 0.0, 99.0)
	if camRot.y > 0.0: camRot.y = clamp(camRot.y - 0.1, 0.0, 99.0)
	elif camRot.y < 0.0: camRot.y = clamp(camRot.y + 0.1, 0.0, 99.0)
	if camRot.z > 0.0: camRot.z = clamp(camRot.z - 0.1, 0.0, 99.0)
	elif camRot.z < 0.0: camRot.z = clamp(camRot.z + 0.1, 0.0, 99.0)
	
	thisCamera.rotation_degrees = camRot

func AddPunchAngle(vector):
	thisCamera.rotation_degrees += vector
	
