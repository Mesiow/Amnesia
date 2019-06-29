extends Node2D

const MuzzleBlast=preload("res://Player/Scenes/MuzzleBlast.tscn")

onready var player=get_parent().get_parent()
onready var sprite=$Sprite
onready var muzzle=$Muzzle
onready var muzzleBlast=$MuzzleBlast
onready var shootTimer=$ShootTimer

onready var shot=$Shot
onready var loaded=$Loaded

var minHitChance = 15
var maxHitChance = 25
var hit = false
var inRange = false
var disabled = true

func _ready():
	toggleOff()
	pass
	
func _process(delta):
	look_at(get_global_mouse_position())
	pass
	

func toggleOn():
	disabled = false
	loaded.play()
	show()
	pass

func toggleOff():
	disabled = true
	hide()
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
		
	if player.seesAnimal and hit: player.hitTarget = true
	
	shot.play()
	shootTimer.start()
	pass

func _on_ShootTimer_timeout():
	player.readyToShoot = true
	pass

func _on_RangeArea_area_entered(area):
	print(area.get_name())
	if area.get_name() == "Deer":
		inRange = true
		print("in range")
	pass

func _on_RangeArea_area_exited(area):
	if area.get_name() == "Deer":
		inRange = false
		print("out of range")
	pass