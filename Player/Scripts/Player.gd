extends KinematicBody2D

var velocity=Vector2()
var speed=150

const Firepit=preload("res://Environment/Scenes/Firepit.tscn")

onready var map = get_parent().get_node("GeneratedMap")
onready var hud = get_parent().get_node("SurvivalHUD")

onready var rifle=$Hands/Rifle
onready var rifleMuzzle=$Hands/Rifle/Muzzle
onready var anim=$AnimatedSprite
onready var footstep=$FootstepGrass
onready var footstepWater=$FootstepWater
onready var itemPickup=$ItemPickup
onready var chew=$Chew
onready var camera=$Camera2D

onready var hungerTimer=$HungerTimer
onready var damagedTimer=$DamagedTimer

var readyToShoot = true
var inWater = false
var hitTarget = false
var seesAnimal = false
var nearKilledAnimal = false
var grabbedFood = false
var closestAnimalDist = Vector2()

signal shotRifle
signal pickedUpFood
signal hunger
signal lifeDropped
signal ateFood
signal playerDied

var life : int = 100
var died : bool = false setget, isAlive
var equipped = {}


func _ready():
	set_physics_process(true)

	equipped.inHand = "Hands" #start game with fists
	
	hungerTimer.wait_time = 1.0
	hungerTimer.start()
	
	damagedTimer.wait_time = 1.0
	pass
	
func _process(delta):
	closestAnimalDist = calculateClosestAnimal()
	if isAnimalInView():
		seesAnimal = true
	else:
		seesAnimal = false
	pass
	
	
func _physics_process(delta):
	velocity=Vector2()
	if get_global_mouse_position().x > global_position.x: #if mouse is on right side face sprite toward there
		anim.flip_h = true
		flipRifle(false)
	else:
		anim.flip_h = false
		flipRifle(true)
	if !died:
		handleInput() # handles all player input

	if velocity == Vector2(0,0):
		anim.stop()
	
	keepPlayerInMap()
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * speed)
	pass


func handleInput():
	handleMovementInput()
	handleInteractionInput()
	pass
	
func isAlive() -> bool:
	return died
	pass

func handleInteractionInput():
	if Input.is_action_pressed("fire_rifle") and equipped["inHand"] == "Rifle": #shoot the gun
		if readyToShoot:
			rifle.shoot()
			emit_signal("shotRifle")
			get_tree().call_group("Animal", "playerFiredGun") #alert nearby deer/animal that the player shot
			readyToShoot = false

	if Input.is_action_just_pressed("pickup"):
		if nearKilledAnimal:
			itemPickup.play()
			emit_signal("pickedUpFood")
			grabbedFood = true
			
	if Input.is_action_just_pressed("eat") and hud.getFoodCounter() > 0:
		emit_signal("ateFood")
		chew.play()
			
	if Input.is_action_just_pressed("use"):
		var pit=Firepit.instance()
		pit.global_position = global_position
		get_tree().get_root().get_node("/root/World").add_child(pit)
	pass

func handleMovementInput():
	if Input.is_action_just_pressed("increase_zoom"):
		camera.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("decrease_zoom"):
		camera.zoom += Vector2(-0.1, -0.1)

	if Input.is_action_just_pressed("switch_items"):
		switchItem()
		
	if Input.is_action_pressed("up"):
		velocity.y = -speed
		handleAnimation()
	elif Input.is_action_pressed("down"):
		velocity.y = speed
		handleAnimation()
		
	if Input.is_action_pressed("left"):
		velocity.x = -speed
		handleAnimation()
	elif Input.is_action_pressed("right"):
		velocity.x = speed
		handleAnimation()
	pass

func switchItem():
	if equipped["inHand"] == "Rifle":
		equipped["inHand"] = "Hands"
		rifle.toggleOff()
	elif equipped["inHand"] == "Hands":
		equipped["inHand"] = "Rifle"
		rifle.toggleOn()
	pass

func handleAnimation():
	if equipped["inHand"] == "Rifle":
		anim.play("movingRifle")
	elif equipped["inHand"] == "Hands":
		anim.play("movingUnarmed")
	pass
	
func isAnimalInView():
	var animalGroup = get_tree().get_nodes_in_group("Animal")
	for animal in animalGroup: 
		var animalDirection = (animal.global_position - global_position).normalized() #direction vector from player to animal
		var playerFacingDir = (get_global_mouse_position() - global_position).normalized()
		if animalDirection.dot(playerFacingDir) > 0: #animal is in view of the direction we are facing
			return true
		else:
			return false
	pass
	
func calculateClosestAnimal():
	var animalGroup = get_tree().get_nodes_in_group("Animal")
	var animalDistances = []
	
	for animal in animalGroup:
		var distanceToUs = animal.global_position.distance_to(global_position)
		animalDistances.append(distanceToUs)
		
	animalDistances.sort() #sort the distances
	if animalDistances.size() > 0:
		var minDist = animalDistances[0]
		for i in range(1, animalDistances.size()):
			minDist = min(minDist, animalDistances[i]) #get min of both
		return minDist
	pass

func _on_AnimatedSprite_animation_finished():
	if !inWater:
		footstep.play()
		return
		
	#else we are in water
	footstepWater.play()
	pass 
	
func flipRifle(val):
	rifle.sprite.flip_v=val
	pass

func _on_Footstep_finished():
	footstep.stop()
	pass
	
func _on_FootstepWater_finished():
	footstepWater.stop()
	pass 
	
func keepPlayerInMap():
	global_position.x = clamp(global_position.x, 0 + map.START_X * map.TILE_SIZE + map.TILE_SIZE, map.MAX_SIZE_X * map.TILE_SIZE - map.TILE_SIZE)
	global_position.y = clamp(global_position.y, 0 + map.START_Y * map.TILE_SIZE + map.TILE_SIZE, map.MAX_SIZE_Y * map.TILE_SIZE - map.TILE_SIZE)
	pass


func _on_HungerTimer_timeout():
	emit_signal("hunger")
	pass

func _on_SurvivalHUD_hungerMaxed():
	damagedTimer.start()
	pass 

func _on_DamagedTimer_timeout():
	emit_signal("lifeDropped")
	pass


func _on_SurvivalHUD_lifeGone():
	died = true
	hide()
	emit_signal("playerDied")
	pass
