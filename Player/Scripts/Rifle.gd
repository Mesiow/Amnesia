extends Node2D

const MuzzleBlast=preload("res://Player/Scenes/MuzzleBlast.tscn")

onready var player=get_parent().get_parent()
onready var sprite=$Sprite
onready var muzzle=$Muzzle
onready var muzzleBlast=$MuzzleBlast
onready var shootTimer=$ShootTimer

onready var shot=$Shot

var minHitChance = 5
var maxHitChance = 25
var hit = false

func _ready():
	pass
	
func _process(delta):
	look_at(get_global_mouse_position())
	pass
	
	
func shoot():
	randomize()
	muzzleBlast.restart()
	muzzleBlast.global_position = muzzle.global_position
	var lifeTime=rand_range(0.5, 1.5)
	muzzleBlast.lifetime = lifeTime
	muzzleBlast.one_shot = true
	muzzleBlast.emitting = true
	
	var hitChance = randi() %maxHitChance + 1
	if hitChance >= minHitChance and hitChance <= maxHitChance: #hit successful
		hit = true
	else:
		hit = false
		
	if hit: player.hitTarget = true
	
	shot.play()
	shootTimer.start()
	pass

func _on_ShootTimer_timeout():
	player.readyToShoot = true
	pass
