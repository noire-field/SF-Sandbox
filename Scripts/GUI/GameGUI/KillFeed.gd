extends VBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var sampleKillNode = get_node("SampleKill")

const MAX_SHOW = 4
var killFeeds = []

# Called when the node enters the scene tree for the first time.
func _ready():
	sampleKillNode.visible = false
	pass
	
func OnTimeOut():
	CheckClearFeed()
	
	#if countTimer >= 8:
	#	return
		
	#print("Create");
	#countTimer += 1
	#MakeKill('User A' + str(countTimer), 'User B' + str(countTimer), true)
	#MakeKill('User A', 'User B', true)
	#MakeKill('User A', 'User B', false)
	
func MakeKill(attackerName, victimName, isHeadshot):
	# Check if max kills are shown
	var childCount = get_child_count()
	
	if childCount-1 >= MAX_SHOW: # Exclude the sample node
		var removeCount = (childCount-1) - MAX_SHOW + 1
		#print("Need To REmove: " + str(removeCount))
		for n in removeCount:
			get_child(childCount-1).queue_free()
			childCount -= 1
		
	# Add Kill to Top
	var newKill = sampleKillNode.duplicate()

	newKill.get_node("Attacker").text = attackerName
	newKill.get_node("Victim").text = victimName
	newKill.get_node("Anime").play("Appear")
	
	if isHeadshot == true: newKill.get_node("Headshot").visible = true
	else: newKill.get_node("Headshot").visible = false
	
	newKill.visible = true
	newKill.name = "KILL_" + str(OS.get_ticks_msec())
	
	
	killFeeds.push_front({
		"removeAt": OS.get_ticks_msec() +  (5 * 1000),
		"nodeName": newKill.name
	})
	
	add_child(newKill)
	move_child(newKill, 0)
	
	# Move sample node back to top but invisible so it can not be accidently deleted
	move_child(sampleKillNode, 0)
	
func CheckClearFeed():
	var feedSize = killFeeds.size()
	if feedSize <= 0: return
	
	var currentTime = OS.get_ticks_msec()
	if currentTime >= killFeeds[feedSize-1]['removeAt']:
		var node = get_node(killFeeds[feedSize-1]['nodeName'])
		if node: node.get_node("Anime").play("Disappear") #node.queue_free() # Animation has contained queue_Free
		killFeeds.pop_back()
