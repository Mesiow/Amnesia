extends Area2D

#base class
var defaultSpeed = 150
export var speed = 150
export var velocity=Vector2()
var moveDir = Vector2()

var player = null

onready var world = get_tree().get_root().get_node("/root/World")
onready var map = get_tree().get_root().get_node("/root/World/GeneratedMap")

onready var anim = $AnimatedSprite
onready var nextMoveTmer=$NextMoveTimer

func _ready():

	pass

func _process(delta):
	if moveDir.x < 0:
		anim.flip_h = true
	else:
		anim.flip_h = false
		
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
		global_position = Vector2(10,10)
		
		moveDir = randomDirection()
	pass
	
	
func randomDirection():
	randomize()
	var dirX = rand_range(-PI, PI)
	var dirY = rand_range(-PI, PI)
	return Vector2(dirX, dirY).normalized()#animal moves in random direction
	pass
	
func flee():
	if player:
		if player.global_position.x < global_position.x:
			moveDir = randomDirection()
			speed = defaultSpeed * 1.5
		else:
			moveDir = randomDirection()
			speed = -defaultSpeed * 1.5
	pass

func _on_VisibilityNotifier2D_viewport_exited(viewport): #animal left the players viewport so delete it
	queue_free()
	pass


func _on_NextMoveTimer_timeout():
	pass # Replace with function body.
