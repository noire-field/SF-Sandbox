extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var currentWeapon = 1

var lastClickTime 
var serverWeaponHandler = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func WeaponFire(release):
	var weapon = null
	if currentWeapon == 1:
		weapon = get_node("RocketLauncher")
	elif currentWeapon == 2:
		weapon = get_node("LaserRifle")
		
	if weapon != null:
		weapon.WeaponFire(release)

func WeaponSubFire(release):
	if release: return
	
	if currentWeapon == 1:
		get_node("RocketLauncher").visible = false
		get_node("LaserRifle").visible = true
		
		currentWeapon = 2
		
	elif currentWeapon == 2:
		get_node("RocketLauncher").visible = true
		get_node("LaserRifle").visible = false
		
		currentWeapon = 1
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
