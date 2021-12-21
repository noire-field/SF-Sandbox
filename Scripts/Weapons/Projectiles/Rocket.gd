extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var rocketJumpRadius = 25
export var rocketJumpPower = 75

var otherClient = false
var ownerNode = null

var smokePrefab = null
var explosionPrefab = null
onready var Anime = get_node("Anime")

var smokeInstance
var explosionInstance

var lastEmit = 0.0
var hit = false

var itemHandler = null

# Called when the node enters the scene tree for the first time.
func _ready():
	hit = false

	smokeInstance = preload('res://Prefabs/Effects/CircleSmoke.tscn').instance()
	smokeInstance.visible = false
	
	explosionInstance = preload('res://Prefabs/Effects/Explosion.tscn').instance()
	explosionInstance.visible = false
	
	Anime.play("Flying")

func _physics_process(delta):
	var current = OS.get_ticks_msec()
	if current >= lastEmit:
		EmitSmoke();
		lastEmit = current + 50
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func EmitSmoke():
	var smoke = smokeInstance.duplicate() as Particles
	
	smoke.visible = true
	get_node("/root").add_child(smoke)
	
	smoke.global_transform.origin = self.global_transform.origin
	smoke.one_shot = true
	smoke.emitting = true
	smoke.speed_scale = 5.0
	#smoke.scale = Vector3(10,10,10)
	
func OnLaserHit(collider):
	if otherClient: 
		queue_free()
		return
		
	if collider.is_in_group("Player"):
		return
		
	if hit: return
	hit = true
	
	var explosion = explosionInstance.duplicate() as Spatial
	
	explosion.visible = true
	get_node("/root").add_child(explosion)
	
	explosion.global_transform.origin = self.global_transform.origin
	explosion.scale = Vector3(3,3,3)
	
	CheckRocketJump(self.global_transform.origin)

	queue_free()
	
func CheckRocketJump(expPos):
	var myPlayer = ownerNode
	if myPlayer and myPlayer.global_transform.origin.distance_to(expPos) <= rocketJumpRadius:
		var vecKick = myPlayer.global_transform.origin - expPos
		vecKick = vecKick.normalized()
		
		myPlayer.ForceFullVelocity(vecKick * rocketJumpPower)
