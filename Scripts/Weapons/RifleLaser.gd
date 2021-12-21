extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var laserInstance
var sparkInstance

onready var muzzleflash = get_node("Muzzleflash")
onready var rayCast = get_node("RayCast")
onready var animationPlayer = get_node("AnimationPlayer")

var weaponRay = null
var weaponRayTip = Vector3(0,0,0)
var playerCamera = null

var firing = false
var lastFire = 0

var serverGunHandler = null
var serverWeaponHandler = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var GameLoader = GlobalController.GetGameLoader()
	
	laserInstance = GameLoader.precached["res://Prefabs/Weapons/Projectiles/Laser.tscn"]
	laserInstance.visible = false
	
	sparkInstance = GameLoader.precached["res://Prefabs/Effects/Spark.tscn"]
	sparkInstance.visible = false
	
	serverWeaponHandler = Server.get_node("PlayerController/Weapon")
	serverGunHandler = Server.get_node("PlayerController/Weapon/RifleLaser")
	
	pass
	
func _process(delta):
	if firing:
		var currentTime = OS.get_system_time_msecs()
		
		if currentTime >= lastFire + 1000:
			FireLaser()
			lastFire = currentTime
		
	else:
		pass
	
func _physics_process(delta):
	var player = get_parent().get_parent()
	if not player.allowControl:
		return
	
	var playerWrapper = player.get_node("Wrapper")
	
	weaponRay = playerWrapper.currentCameraRoot.get_node("H/V/Camera/WeaponRay") as RayCast # Camera can be switched between 1st and 3rd
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func FireLaser():
	var laser = laserInstance.duplicate()
	laser.visible = true
	
	var spark = sparkInstance.duplicate()
	spark.visible = true
	
	var GameScene = GlobalController.GetGameScene()
	var spawns = GameScene.get_node("Spawns")
	var crosshair = GameScene.get_node("CanvasLayer/Crosshair") as Control
	#
		
	crosshair.fire(1.0)

		
	spawns.add_child(laser)
	spawns.add_child(spark)
	
	var result = GetHitPosition()
	var hitPosition =  result[1]
	
	print("Hit Type: " + str(result[0]) + " / Position: " + str(result[1]))
	if result[0] == 1:
		var target = result[2] as PhysicsBody
		
		if target.is_in_group("Enemies"):
			var isHeadshot = false
			if result[3] == 1: isHeadshot = true
			
			print("Deal Damage to: " + target.name)
			print("Is Headshot: " + str(isHeadshot))
			
			serverGunHandler.DealDamageTo(target.name, isHeadshot)
		
	var startPos = muzzleflash.global_transform.origin
	var velocity = (hitPosition - laser.global_transform.origin)
	
	laser.global_transform.origin = startPos
	
	var distance = startPos.distance_to(hitPosition)
	
	laser.look_at(hitPosition, Vector3.UP)
	
	var subLaser = laser.get_node("Laser")
	
	var laserMesh = subLaser.mesh.duplicate() as CylinderMesh;
	
	laserMesh.height = distance
	laserMesh.top_radius = 0.15
	laserMesh.bottom_radius = 0.15
	
	PlayAnimation("Firing")
	
	serverGunHandler.LaserGunFire(laser.global_transform.origin, laser.rotation, distance)
	serverWeaponHandler.AddPunchAngle(Vector3(4,rand_range(-2.5, 2.5),0))
	
	subLaser.mesh = laserMesh;
	#print(distance)
	
	laser.translate_object_local(Vector3(0,0,(distance / 2) * -1))
	
	var fireSound = get_node("Sounds/Firing")
	fireSound.play()
	
	#var particles = get_node("Node/Particles") as Particles
	
	spark.scale = Vector3(0.15, 0.15, 0.15)
	spark.global_transform.origin = muzzleflash.global_transform.origin
	spark.emitting = true
	spark.one_shot = true
	
	
	#particles.emitting = true
	#particles.one_shot = true
	
	#laser.connect("body_entered", self, "OnLaserHit")
	
func GetHitPosition():
	if rayCast.is_colliding() && (rayCast.get_collision_point() - rayCast.global_transform.origin).length() > 0.1:
		return [1, rayCast.get_collision_point(), rayCast.get_collider(), rayCast.get_collider_shape()]
	else:
		return [0, (rayCast.get_cast_to().z * rayCast.global_transform.basis.z) + rayCast.global_transform.origin, null]
		
	
func PlayAnimation(name, speed=1.0):
	animationPlayer.playback_speed = speed
	animationPlayer.stop()
	animationPlayer.play(name)
