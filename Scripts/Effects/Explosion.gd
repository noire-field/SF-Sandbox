extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Explosion = get_node("Explosion")
onready var Smoke = get_node("Smoke")
onready var Sparks = get_node("Sparks")

var createdAt = 0
var killed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	killed = false
	createdAt = OS.get_ticks_msec() + 3000
	
	Explosion.one_shot = true
	Explosion.emitting = true
	
	Smoke.one_shot = true
	Smoke.emitting = true
	
	Sparks.one_shot = true
	Sparks.emitting = true
	
	get_node("Sounds/Explosion"+str(int(rand_range(1,5)))).play()
	#get_node("Sounds/Explosion1").play()
	
	pass # Replace with function body.

func _physics_process(delta):
	if killed: return
	if OS.get_ticks_msec() >= createdAt:
		killed = true
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
