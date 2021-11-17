extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = get_node("Player")
onready var playerWrapper = get_node("Player/Wrapper")

# Called when the node enters the scene tree for the first time.
func _ready():
	var scale = 3.0
	
	get_node("Player/CollisionShape").scale = Vector3(scale, scale, scale)
	get_node("Player/BodyModel/B88").scale = Vector3(scale, scale, scale)
	playerWrapper.get_node("CameraRoot/H/V/Camera").make_current()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	get_node("Player/BodyModel").scale = Vector3(2.0, 2.0, 2.0)
