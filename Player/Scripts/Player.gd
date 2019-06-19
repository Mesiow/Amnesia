extends KinematicBody2D

var velocity=Vector2()
var speed=150

onready var rifle=$Hands/Rifle
onready var anim=$AnimatedSprite
onready var footstep=$Footstep

var readyToShoot = true

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
			readyToShoot = false
		
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
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * speed)
	pass

func _on_AnimatedSprite_animation_finished():
	footstep.play()
	pass 
	
func flipRifle(val):
	rifle.sprite.flip_v=val
	pass


func _on_Footstep_finished():
	footstep.stop()
	pass
