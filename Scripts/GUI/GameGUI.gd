extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Anime = get_node("Anime")
onready var AnimeIdle = get_node("AnimeIdle")
onready var hpValue = get_node("VerticalGrid/Bottom/Left/HPValue")
onready var hpProgress = get_node("VerticalGrid/Bottom/Left/HPProgress")

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("Vox/Headshot").play()
	AnimeIdle.play("BuffIdle")

func SetHP(current, maxHP):
	var percent =  int(float(current) / float(maxHP) * 100.0)
	
	var tween = get_node("VerticalGrid/Bottom/Left/HPProgress/Tween")
	tween.interpolate_property(hpProgress, 'value', hpProgress.value, percent, 0.25, Tween.TRANS_LINEAR,  Tween.EASE_IN_OUT)
	tween.start()
	#hpProgress.value = percent
	
	hpValue.text = str(current)
	Anime.play("HPSpark")
	
	if percent >= 60: hpProgress.set_tint_progress("14E114")
	elif percent >= 30: hpProgress.set_tint_progress("E1BE32")
	else: hpProgress.set_tint_progress("E11E1E")
	
func UpdateStatusText(text):
	var statusText = get_node("VerticalGrid/Top/Left/StatusText")
	statusText.text = text

func SetLatency(ping):
	var pingText = get_node("VerticalGrid/Bottom/Left/Control2/LabelPING")
	pingText.text = "PING: " + str(ping)

func SetSpeed(speed):
	var speedText = get_node("VerticalGrid/Bottom/Right/Control/HPValue2")
	speedText.text = str(speed)
	pass
	
func SetFPS(fps):
	var fpsText = get_node("VerticalGrid/Bottom/Left/Control2/LabelFPS")
	fpsText.text = "FPS: " + str(fps)

func AddKill(attackerName, victimName, isHeadshot):
	get_node("VerticalGrid/Top/Right/KillFeed").MakeKill(attackerName, victimName, isHeadshot)
	if isHeadshot: AddHeadshot()

func AddHeadshot():
	var headshotAnime = get_node("VerticalGrid/Top/Center/AnimeHeadshot")
	headshotAnime.stop(true)
	headshotAnime.play("Headshot")
	get_node("VerticalGrid/Bottom/Center/HSList").AddHeadshot()
	get_node("Vox/Headshot").play(0.0)
