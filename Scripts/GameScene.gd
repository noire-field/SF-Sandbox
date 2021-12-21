extends Spatial

var level
var otherPlayerSpawnPos = {}
var otherPlayerLastDie = {}

var isPlayerAlive = false
var myPlayer = null
var myPlayerState
var myPlayerId = 0
var mySpawnLocation = []

var playerStatesBuffer = []
var lastPlayerState = 0
var interpolationOffset = 100

var mouseLock = true
var GameLoader = null
var StateProcessing = null

func _ready():
	GameLoader = get_parent()
	StateProcessing = Server.get_node("StateProcessing")
	
	print("GameScene Loaded, initing GUI...")
	InitGUI()
	print("GUI loaded, loading Map...")
	InitializeLevel()
	print("Map loaded, loading Camera...")
	LoadDefaultCamera()
	print("Camera loaded, joining game...")
	JoinGame()
	ConfigureConsole()
	
func _input(event):
	if event.is_action_pressed("quentincaffeino_console_toggle"):
		if mouseLock == true:
			mouseLock = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouseLock = true
	
func ConfigureConsole():
	Console.add_command('p_movespeed', self, 'ConSetDefaultSpeed').set_description('Default Move Speed (Default: 20.0)').add_argument('value', TYPE_REAL).register()
	Console.add_command('p_runaccel', self, 'ConSetRunAccel').set_description('Run Acceleration (Default: 35.0)').add_argument('value', TYPE_REAL).register()
	Console.add_command('p_rundeaccel', self, 'ConSetRunDeaccel').set_description('Run Deacceleration (Default: 1.5)').add_argument('value', TYPE_REAL).register()
	Console.add_command('p_airaccel', self, 'ConSetAirAccel').set_description('Air Acceleration (Default: 35.0)').add_argument('value', TYPE_REAL).register()
	Console.add_command('p_airdeaccel', self, 'ConSetAirDeaccel').set_description('Air Deacceleration (Default: 0.0)').add_argument('value', TYPE_REAL).register()
	Console.add_command('p_sidestrafeaccel', self, 'ConSetSideStrafeAccel').set_description('Side Strafe Acceleration (Default: 500.0)').add_argument('value', TYPE_REAL).register()
	Console.add_command('p_sidestrafespeed', self, 'ConSetSideStrafeSpeed').set_description('Side Strafe Acceleration (Default: 1.0)').add_argument('value', TYPE_REAL).register()
	Console.add_command('p_jumpspeed', self, 'ConSetJumpSpeed').set_description('Jump Speed (Default: 15.0)').add_argument('value', TYPE_REAL).register()
	Console.add_command('p_fric', self, 'ConSetFriction').set_description('Friction (Default: 0.5)').add_argument('value', TYPE_REAL).register()
	Console.add_command('p_airfric', self, 'ConSetAirFric').set_description('Air Friction (Default: 0.0)').add_argument('value', TYPE_REAL).register()
	Console.add_command('p_gravity', self, 'ConSetGravity').set_description('Gravity (Default: 20.0)').add_argument('value', TYPE_REAL).register()

func ConSetDefaultSpeed(value = Server.serverCvars[0]): Server.ToServer_SetCvar(0, float(value))
func ConSetRunAccel(value = Server.serverCvars[1]): Server.ToServer_SetCvar(1, float(value))
func ConSetRunDeaccel(value = Server.serverCvars[2]): Server.ToServer_SetCvar(2, float(value))
func ConSetAirAccel(value = Server.serverCvars[3]): Server.ToServer_SetCvar(3, float(value))
func ConSetAirDeaccel(value = Server.serverCvars[4]): Server.ToServer_SetCvar(4, float(value))
func ConSetSideStrafeAccel(value = Server.serverCvars[5]): Server.ToServer_SetCvar(5, float(value))
func ConSetSideStrafeSpeed(value = Server.serverCvars[6]): Server.ToServer_SetCvar(6, float(value))
func ConSetJumpSpeed(value = Server.serverCvars[7]): Server.ToServer_SetCvar(7, float(value))
func ConSetFriction(value = Server.serverCvars[8]): Server.ToServer_SetCvar(8, float(value))
func ConSetAirFric(value = Server.serverCvars[9]): Server.ToServer_SetCvar(9, float(value))
func ConSetGravity(value = Server.serverCvars[10]): Server.ToServer_SetCvar(10, float(value))
	
func ApplyCvar(id, value):
	match int(id):
		0: get_node("MyPlayer").defaultmoveSpeed = float(value)
		1: get_node("MyPlayer").runAcceleration = float(value)
		2: get_node("MyPlayer").runDeacceleration = float(value)
		3: get_node("MyPlayer").airAcceleration = float(value)
		4: get_node("MyPlayer").airDecceleration = float(value)
		5: get_node("MyPlayer").sideStrafeAcceleration = float(value)
		6: get_node("MyPlayer").sideStrafeSpeed = float(value)
		7: get_node("MyPlayer").jumpSpeed = float(value)
		8: get_node("MyPlayer").friction = float(value)
		9: get_node("MyPlayer").airfriction = float(value)
		10: get_node("MyPlayer").gravity = float(value)
		
func _process(delta):
	UpdateText()
	
func _physics_process(delta):
	#Server To Player
	ProcessWorldState(delta)
	
	StateProcessing.SendPlayerState(myPlayer, isPlayerAlive)
	
func InitGUI():
	var GameGUI = GameLoader.precached["res://Scenes/GUI/GameGUI.tscn"]
	GameGUI.name = "GameGUI"
	get_node("GUI").add_child(GameGUI)
	
func InitializeLevel():
	# Load the map

	#level = GameLoader.precached['res://pvpdm1_v3.tscn']
	level = GameLoader.precached['res://QuakeMap.tscn']
	level.name = "Level"
	
	add_child(level)
	
	# Scan the spawn points
	# (Disabled on 11-02-2021)
	#var locations = level.get_node("PlayerSpawns").get_children()
	#for loc in locations:
	#	spawnLocations.append(loc.transform.origin)
		
	#print(spawnLocations)
	pass

func LoadDefaultCamera():
	pass
	#level.get_node("DefaultCamera").make_current()

func JoinGame():
	Server.JoinGame(get_instance_id())
	pass
	
func CreateMyPlayer(spawnLocation, playerId):
	var player = GameLoader.precached["res://Prefabs/Player.tscn"].duplicate()
	var playerWrapper = GameLoader.precached["res://Scenes/Wrapper.tscn"].duplicate()
	
	playerWrapper.name = "Wrapper"
	
	mySpawnLocation = spawnLocation
	
	add_child(player)
	player.transform.origin = Vector3(spawnLocation[0], spawnLocation[1], spawnLocation[2])
	player.scale = Vector3(2.5, 2.5, 2.5)
	player.add_child(playerWrapper)
	player.name = "MyPlayer"
	player.add_to_group("Player")
	player.CheckBodyVisibility()
	
	playerWrapper.MakeCameraCurrent()
	
	isPlayerAlive = true
	myPlayer = player
	myPlayerId = playerId
	
	Server.get_node("PlayerController").myPlayerId = playerId
	
	print("Player created!")

func CreateOtherPlayer(playerId, spawnLocation):
	var player = GameLoader.precached["res://Prefabs/Player.tscn"].duplicate()
	
	otherPlayerSpawnPos[int(playerId)] = Vector3(spawnLocation[0], spawnLocation[1], spawnLocation[2])
	otherPlayerLastDie[int(playerId)] = 0
	
	player.transform.origin = Vector3(spawnLocation[0], spawnLocation[1], spawnLocation[2])
	player.name = str(playerId)
	player.add_to_group("Enemies")
	player.SetControl(false)
	
	get_node("OtherPlayers").add_child(player)
	print("Create other:" + str(playerId))

func DespawnPlayer(playerId):
	yield(get_tree().create_timer(0.2), "timeout")
	
	if otherPlayerSpawnPos.has(int(playerId)):
		otherPlayerSpawnPos.erase(int(playerId))
		otherPlayerLastDie.erase(int(playerId))
	
	var thatPlayer = get_node("OtherPlayers/" + str(playerId))
	if thatPlayer: thatPlayer.queue_free()
	
	print("Player despawned:" + str(playerId))

func UpdatePlayerStates(playerStates):
	if playerStates["Time"] > lastPlayerState:
		lastPlayerState = playerStates["Time"]
		playerStatesBuffer.append(playerStates)
			
var currentStateType = 0		

func ProcessWorldState(delta):
	var renderTime = OS.get_system_time_msecs() - interpolationOffset #clamp(interpolationOffset + StateProcessing.receiveTimeDelay, 100, 300)
	if playerStatesBuffer.size() > 1:
		while playerStatesBuffer.size() > 2 and renderTime > playerStatesBuffer[2]['Time']:
			playerStatesBuffer.remove(0)
			
		if playerStatesBuffer.size() > 2:
			if currentStateType != 1:
				currentStateType = 1
				print("Switch to Interpolation")
				
			var interpolationFactor = float(renderTime - playerStatesBuffer[1]["Time"]) / float(playerStatesBuffer[2]["Time"] - playerStatesBuffer[1]["Time"])
			
			for player in playerStatesBuffer[2]['List'].keys():
				if player == int(get_tree().get_network_unique_id()):
					continue
				if not playerStatesBuffer[1]['List'].has(player):
					continue
				if get_node("OtherPlayers").has_node(str(player)):
					var playerNode = get_node("OtherPlayers/" + str(player))
					
					if playerStatesBuffer[1]['List'][player].has('P') and playerStatesBuffer[2]['List'][player].has('P'):
						var newPosition = lerp(playerStatesBuffer[1]['List'][player]["P"], playerStatesBuffer[2]['List'][player]["P"], interpolationFactor)
						
						var currentTime = OS.get_system_time_msecs()
						if currentTime >= (otherPlayerLastDie[int(player)] + 1000):
							playerNode.transform.origin = newPosition
							if playerNode.visible == false:
								playerNode.visible = true
					
					if playerStatesBuffer[1]['List'][player].has('R') and playerStatesBuffer[2]['List'][player].has('R'):
						var quatRotationA = Quat(playerStatesBuffer[1]['List'][player]["R"])
						var quatRotationB = Quat(playerStatesBuffer[2]['List'][player]["R"])
						var quatRotation = quatRotationA.slerp(quatRotationB, interpolationFactor)
						playerNode.get_node("BodyModel").global_transform.basis = Basis(quatRotation)
					
					if playerStatesBuffer[1]['List'][player].has('RR') and playerStatesBuffer[2]['List'][player].has('RR'):
						var RquatRotationA = Quat(playerStatesBuffer[1]['List'][player]["RR"])
						var RquatRotationB = Quat(playerStatesBuffer[2]['List'][player]["RR"])
						var RquatRotation = RquatRotationA.slerp(RquatRotationB, interpolationFactor)
						playerNode.global_transform.basis = Basis(RquatRotation)
				else:
					if playerStatesBuffer[2]['List'][player].has('P'):
						print("Recreate player 1")
						CreateOtherPlayer(player, playerStatesBuffer[2]['List'][player]["P"])
					else:
						print("Recreate player 1 Default Pos")
						CreateOtherPlayer(player, Vector3(0, 0, 0))
		elif renderTime > playerStatesBuffer[1]['Time']:
			if currentStateType != 2:
				currentStateType = 2
				print("Switch to Extrapolation")
				
			var extrapolationFactor = float(renderTime - playerStatesBuffer[0]["Time"]) / float(playerStatesBuffer[1]["Time"] - playerStatesBuffer[0]["Time"]) - 1.00
			for player in playerStatesBuffer[1]['List'].keys():
				if player == int(get_tree().get_network_unique_id()):
					continue
				if not playerStatesBuffer[0]['List'].has(player):
					continue
				
				if get_node("OtherPlayers").has_node(str(player)):
					var playerNode = get_node("OtherPlayers/" + str(player))
					
					if playerStatesBuffer[1]['List'][player].has('P') and playerStatesBuffer[0]['List'][player].has('P'):
						var positionDelta = playerStatesBuffer[1]['List'][player]["P"] - playerStatesBuffer[0]['List'][player]["P"]
						
						var tempFactor = extrapolationFactor
						if positionDelta.x == 0 and positionDelta.y == 0 and positionDelta.z == 0:
							tempFactor = 0.0
						
						var newPosition = playerStatesBuffer[1]['List'][player]["P"] + (positionDelta * tempFactor)
						playerNode.transform.origin = newPosition
						
					if playerStatesBuffer[1]['List'][player].has('R') and playerStatesBuffer[0]['List'][player].has('R'):
						var quatRotationA = Quat(playerStatesBuffer[0]['List'][player]["R"])
						var quatRotationB = Quat(playerStatesBuffer[1]['List'][player]["R"])
						var rotationDelta = quatRotationB - quatRotationA
						
						var newRotation = Quat(playerStatesBuffer[1]['List'][player]["R"]) + (rotationDelta * extrapolationFactor)
						playerNode.get_node("BodyModel").global_transform.basis = Basis(newRotation)
						
					if playerStatesBuffer[1]['List'][player].has('RR') and playerStatesBuffer[0]['List'][player].has('RR'):
						var RquatRotationA = Quat(playerStatesBuffer[0]['List'][player]["RR"])
						var RquatRotationB = Quat(playerStatesBuffer[1]['List'][player]["RR"])
						var RrotationDelta = RquatRotationB - RquatRotationA
						
						var newRRotation = Quat(playerStatesBuffer[1]['List'][player]["RR"]) + (RrotationDelta * extrapolationFactor)
						playerNode.global_transform.basis = Basis(newRRotation)
				else:
					if playerStatesBuffer[1]['List'][player].has('P'):
						print("Recreate player 2")
						CreateOtherPlayer(player, playerStatesBuffer[1]['List'][player]["P"])
					else:
						print("Recreate player 2 Default Pos")
						CreateOtherPlayer(player, Vector3(0, 0, 0))
			#print("Extrapolation")

func OnTimer1SecondOut():
	var latency = Server.GetLatency()
	interpolationOffset = 100 #clamp(latency + 25, 100, 300)
	
	var mode = "unknown"
	
	if currentStateType == 1: mode = "(Interpolation: " + str(interpolationOffset) + ")"
	elif currentStateType == 2: mode = "(Extrapolation: " + str(interpolationOffset) + ")"
	
	get_node("GUI/GameGUI").SetLatency(str(latency) + " " + mode)

func UpdateText():
	var GameGUI = get_node("GUI/GameGUI")
	if myPlayer != null:
		var playerSpeed = int(myPlayer.absPlayerVelocity.length())
		GameGUI.SetSpeed(playerSpeed)
		
	GameGUI.SetFPS(Engine.get_frames_per_second())
	
func PlayerDie(playerId):
	# Who dies?
	if playerId == myPlayerId: # Me die
		# Respawn right away
		myPlayer.transform.origin = Vector3(mySpawnLocation[0], mySpawnLocation[1], mySpawnLocation[2])
	else:
		var otherPlayer = get_node("OtherPlayers/" + str(playerId))
		if otherPlayer:
			otherPlayer.transform.origin = otherPlayerSpawnPos[int(playerId)]
			otherPlayerLastDie[int(playerId)] = OS.get_system_time_msecs()
			otherPlayer.visible = false
			print("Return the player")
