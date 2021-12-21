extends Particles


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var createdAt = 0
var killed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	killed = false
	createdAt = OS.get_ticks_msec() + 500
	pass
	
func _physics_process(delta):
	if killed: return
	if OS.get_ticks_msec() >= createdAt:
		killed = true
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
