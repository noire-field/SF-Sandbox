extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal AddPunchAngle(vector)

var rocketInstance

onready var muzzleflash = get_node("Muzzleflash")
onready var rayCast = get_node("RayCast")
onready var animationPlayer = get_node("Anime")

var weaponRay = null
var weaponRayTip = Vector3(0,0,0)
var playerCamera = null

var firing = false
var lastFire = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rocketInstance = preload('res://Prefabs/Weapons/Projectiles/Rocket.tscn').instance()
	rocketInstance.visible = false

	pass
	
func _process(delta):
	if firing:
		var currentTime = OS.get_system_time_msecs()
		
		if currentTime >= lastFire + 1000:
			FireRocket()
			lastFire = currentTime
		
	else:
		pass
	
func _physics_process(delta):
	var parent = get_parent().get_parent()
	if not parent.allowControl:
		return
	
	var playerWrapper = parent.get_node("Wrapper")
	
	weaponRay = playerWrapper.get_node("CameraRoot/H/V/Camera/WeaponRay") as RayCast # Camera can be switched between 1st and 3rd
	if !weaponRay:
		return
		
	var lookAhead = (weaponRay.get_cast_to().z * weaponRay.global_transform.basis.z) + weaponRay.global_transform.origin
		
	if weaponRay.is_colliding() && (weaponRay.get_collision_point() - weaponRay.global_transform.origin).length() > 0.1:
		weaponRayTip = weaponRay.get_collision_point()
	else:
		weaponRayTip = lookAhead
	
	look_at(lookAhead, Vector3.UP)
	rayCast.look_at(weaponRayTip, Vector3.UP)
	
	

	#$Particles.global_transform.origin = weaponRayTip
	#print(weaponRayTip)

func WeaponFire(release):
	var player = get_parent().get_parent()
	if not player.allowControl:
		return
	
	
	firing = !release
	
	if !release:
		pass
		
	
	else:
		pass
		
func FireRocket():

	var rocket = rocketInstance.duplicate()
	
	rocket.visible = true
	get_node("/root").add_child(rocket)
	
	var startPos = muzzleflash.global_transform.origin
	
	rocket.global_transform.origin = startPos
	
	var velocity = (weaponRayTip - rocket.global_transform.origin) as Vector3
	
	rocket.look_at(weaponRayTip, Vector3.UP)
	rocket.linear_velocity = velocity.normalized() * 200
	
	rocket.ownerNode = get_parent().get_parent()
	#rocket.itemHandler = serverGunHandler
	
	emit_signal("AddPunchAngle", Vector3(6,rand_range(-3.5, 3.5),0))
	PlayAnimation("Firing")
	PlaySound("Firing")
	
	#serverGunHandler.FireRocket(rocket.global_transform.origin, rocket.rotation, rocket.linear_velocity)
	
	pass
	
func PlayAnimation(name, speed=1.0):
	animationPlayer.playback_speed = speed
	animationPlayer.stop()
	animationPlayer.play(name)

func PlaySound(name):
	var sound = get_node("Sounds").get_node(name) as AudioStreamPlayer
	sound.play()
