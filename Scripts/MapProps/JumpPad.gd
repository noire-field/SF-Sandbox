extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var boostBaseValue = 7
export var boostMultiplier = 7
export var speedLockTime = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func OnEnter(body):
	if not body.is_in_group("Player"):
		return
		
	var velocity;
	var magnetude;
	
	velocity = body.playerVelocity
	velocity.y = boostBaseValue;
	#magnetude = body.playerVelocity.length() * boostMultiplier;
	magnetude = boostMultiplier;

	body.ForceVerticalBoost(velocity * magnetude, magnetude, speedLockTime)
	#print("Kick at " + str(boostBaseValue) + " mul by " + str(boostMultiplier))
