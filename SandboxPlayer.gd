extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = get_node("Player")
onready var playerWrapper = get_node("Player/Wrapper")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.scale = Vector3(2.5, 2.5, 2.5)
	playerWrapper.get_node("CameraRoot/H/V/Camera").make_current()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
