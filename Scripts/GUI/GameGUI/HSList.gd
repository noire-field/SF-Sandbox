extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var sampleHSNode = get_node("SampleHS")
const MAX_SHOW = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("SampleHS").visible = false
	pass # Replace with function body.

func AddHeadshot():
	if get_child_count()-1 >= MAX_SHOW:
		get_child(get_child_count()-1).get_node("Anime").play('Appear')
		return
	
	var newHS = sampleHSNode.duplicate()
	newHS.visible = true
	add_child(newHS)
	newHS.get_node("Anime").play('Appear')
