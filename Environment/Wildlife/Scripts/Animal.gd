extends Area2D

#base class
var defaultSpeed = 150
export var speed = 150
export var velocity=Vector2()
var moveDir = Vector2()
var direction = Vector2()

var feeding = false
var fled = false
var dead = false

var player = null
var distanceToPlayer = null

onready var world = get_tree().get_root().get_node("/root/World")
onready var map = get_tree().get_root().get_node("/root/World/GeneratedMap")

onready var anim = $AnimatedSprite
onready var nextMoveTmer=$NextMoveTimer

func _ready():
	add_to_group("Animal")
	nextMoveTmer.start()
	pass

func _process(delta):
	if speed < 0 or moveDir.x < 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
	
	if player:
		distanceToPlayer = global_position.distance_to(player.global_position)
		#if player.hitTarget: #if player hit animal with rifle
		#	if !dead:
		#		kill()
		
	if !feeding and !dead:
		anim.play("moving")
	translate(speed * moveDir * delta)
	pass

func setPlayer(p):
	player = p
	pass
	
func playerFiredGun():
	flee()
	pass

func spawn():
	if world:
		randomize()
		var boundsX = map.WORLD_SIZE_X
		var boundsY = map.WORLD_SIZE_Y
		var spawnX = rand_range(-boundsX, boundsX) #choose a random spot on the map to spawn animal
		var spawnY = rand_range(-boundsY, boundsY)
		
		global_position = Vector2(spawnX, spawnY)
		global_position = Vector2(0,0)
		moveDir = randomDirection()
	pass
	
	
func randomDirection():
	randomize()
	var dirX = rand_range(-PI/2, PI/2)
	var dirY = rand_range(-PI/2, PI/2)
	return Vector2(dirX, dirY).normalized()#animal moves in random direction
	pass
	
func flee():
	if !fled:
		if player:
			if player.global_position.x < global_position.x:
				moveDir = randomDirection()
				speed = defaultSpeed * 1.8
			else:
				moveDir = -randomDirection()
				speed = defaultSpeed * 1.8
			fled = true
	pass

func kill():
	dead = true
	speed = 0
	anim.play("death")
	anim.stop()
	pass
	
func feed():
	feeding = true
	speed = 0
	anim.stop()
	anim.play("feed")
	pass
	
func move(): #function to start moving the animal again
	wait()
	speed = defaultSpeed
	moveDir = randomDirection()
	pass
	
func wait():
	randomize()
	var waitTime = rand_range(0.5, 1.5)
	yield(get_tree().create_timer(waitTime), "timeout")
	pass
	
func _on_VisibilityNotifier2D_viewport_exited(viewport): #animal left the players viewport so delete it
	queue_free()
	pass


func _on_NextMoveTimer_timeout():
	randomize()
	if !fled:
		feed()
		
	nextMoveTmer.wait_time = rand_range(0.0, 5.0)
	nextMoveTmer.start()
	pass 


func _on_AnimatedSprite_animation_finished():
	if anim.animation == "feed":
		anim.stop()
		feeding = false
		move()
	pass
