extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var jumpSounds = [
	preload("res://Sounds/Players/Jump01.wav"), 
	preload("res://Sounds/Players/Jump02.wav")
]

var lastJumpTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func Jump():
	var currentTime = OS.get_system_time_msecs()
	
	if currentTime - lastJumpTime < 500 :
		return
	
	#jumpNode.stream.audio_stream = jumpSounds[0] #jumpSounds[rand_range(0, jumpSounds.size()-1)]
	var jumpNode = get_node("Jump"+str(int(rand_range(1, 2))))
	jumpNode.play()
	
	lastJumpTime = currentTime
	
	print("Jump at " + str(currentTime))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
