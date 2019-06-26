extends KinematicBody2D

var velocity=Vector2()
var speed=150

const Firepit=preload("res://Environment/Scenes/Firepit.tscn")

onready var map = get_parent().get_node("GeneratedMap")

onready var rifle=$Hands/Rifle
onready var rifleMuzzle=$Hands/Rifle/Muzzle
onready var anim=$AnimatedSprite
onready var footstep=$FootstepGrass
onready var footstepWater=$FootstepWater
onready var camera=$Camera2D
onready var lookingDir=$LookingDirection

var readyToShoot = true
var inWater = false
var hitTarget = false

func _ready():
	set_physics_process(true)
	pass
	
func _process(delta):
	var minDistance = calculateClosestAnimal()
	if isAnimalInView():
		pass#print("In view")
	else:
		pass#print("not in view")
		
	print(minDistance)
	pass
	
	
func _physics_process(delta):
	velocity=Vector2()
	if get_global_mouse_position().x > global_position.x: #if mouse is on right side face sprite toward there
		anim.flip_h = true
		flipRifle(false)
	else:
		anim.flip_h = false
		flipRifle(true)
		
	if Input.is_action_pressed("fire_rifle"):
		if readyToShoot:
			rifle.shoot()
			get_tree().call_group("Animal", "playerFiredGun") #alert nearby deer that the player shot
			readyToShoot = false
			
	if Input.is_action_just_pressed("use"):
		var pit=Firepit.instance()
		pit.global_position = global_position
		get_tree().get_root().get_node("/root/World").add_child(pit)
		
	if Input.is_action_just_pressed("increase_zoom"):
		camera.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("decrease_zoom"):
		camera.zoom += Vector2(-0.1, -0.1)
		
	if Input.is_action_pressed("up"):
		velocity.y = -speed
		anim.play("moving")
	elif Input.is_action_pressed("down"):
		velocity.y = speed
		anim.play("moving")
		
	if Input.is_action_pressed("left"):
		velocity.x = -speed
		anim.play("moving")
	elif Input.is_action_pressed("right"):
		velocity.x = speed
		anim.play("moving")
	
	if velocity == Vector2(0,0): #not moving
	
		anim.stop()
	
	keepPlayerInMap()
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * speed)
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
	
func justShot():
	if Input.is_action_just_pressed("fire_rifle") and readyToShoot:
		return true
		
	return false
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
