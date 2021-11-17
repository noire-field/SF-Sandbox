extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mouseSen = 0.2
var playerScale = 3.0

onready var player = get_node("Player")
onready var playerWrapper = get_node("Player/Wrapper")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Player/CollisionShape").scale = Vector3(playerScale, playerScale, playerScale)
	get_node("Player/BodyModel/B88").scale = Vector3(playerScale, playerScale, playerScale)
	playerWrapper.get_node("CameraRoot/H/V/Camera").make_current()
	
	ClientSetting.mouseSensitivityH = mouseSen;
	ClientSetting.mouseSensitivityV = mouseSen;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	get_node("Player/BodyModel").scale = Vector3(2.0, 2.0, 2.0)
