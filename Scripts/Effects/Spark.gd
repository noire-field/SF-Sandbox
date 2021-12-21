extends Particles


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_child(timer)
	
	timer.connect("timeout", self, "RemoveSelf")
	timer.set_wait_time(1.5)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func RemoveSelf():
	queue_free()
