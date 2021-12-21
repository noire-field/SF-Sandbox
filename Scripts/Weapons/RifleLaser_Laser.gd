extends RigidBody

var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_child(timer)
	
	#get_node("AnimationPlayer").play("Disappear")
	
	timer.connect("timeout", self, "RemoveSelf")
	timer.set_wait_time(0.5)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func RemoveSelf():
	queue_free()
