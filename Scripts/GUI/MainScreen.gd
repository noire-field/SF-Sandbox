extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var gameLoader = get_parent()
onready var animator = get_node("Anime")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func SetInGame():
	get_node("Home/VBoxContainer/VBoxContainer/FindGame").disabled = true
	

func ShowSetting():
	animator.play("HomeToSetting")

func ReturnHomeFrom(page):
	animator.play("SettingToHome")
	#var timer = Timer.new()

	#self.add_child(timer)
	
	#get_node("AnimationPlayer").play("Disappear")
	
	#timer.connect("timeout", self, "RemoveSelf")
	#timer.set_wait_time(0.5)
	#timer.start()
	
	pass

func JoinHome():
	animator.play("StartHome")
