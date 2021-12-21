extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var controllerNode = null
var itemID = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func OnBodyEnter(body: KinematicBody):
	if !body: return
	if controllerNode == null:
		return
	if !body.is_in_group("Player"):
		return
	
	controllerNode.TouchItem(body, self)

func SetControllerNode(controller):
	controllerNode = controller
