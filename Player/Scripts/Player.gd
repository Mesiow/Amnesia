extends KinematicBody2D

var velocity=Vector2()
var speed=150

const Firepit=preload("res://Environment/Scenes/Firepit.tscn")

onready var map = get_parent().get_node("GeneratedMap")

onready var rifle=$Hands/Rifle
onready var anim=$AnimatedSprite
onready var footstep=$FootstepGrass
onready var footstepWater=$FootstepWater
onready var camera=$Camera2D

var readyToShoot = true
var inWater = false

func _ready():
	set_physics_process(true)
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
