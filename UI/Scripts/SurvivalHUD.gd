extends CanvasLayer

onready var life = $Life
onready var food = $Food
onready var days = $Days 
onready var hunger = $Hunger 
onready var ammo = $Ammo



var startingLife = 100
var startingAmmo = 25
var startingFood = 0
var startingDay = 0
var startingHunger = 0

signal hungerMaxed
signal lifeGone

func _ready():
	life.text = life.text + str(startingLife)
	food.text = food.text + str(startingFood)
	days.text = days.text + str(startingDay)
	hunger.text = hunger.text + str(startingHunger)
	ammo.text = ammo.text + str(startingAmmo)
	pass


func getFoodCounter():
	return startingFood
	pass
	
func _on_Player_shotRifle():
	if startingAmmo <= 0: return
	startingAmmo-=1
	ammo.text = "Ammo: " + str(startingAmmo)
	pass 

func _on_Player_pickedUpFood():
	startingFood+=1
	food.text = "Food: " + str(startingFood)
	pass 

func _on_DayNightCycle_dayEnded():
	startingDay+=1
	days.text = "Day: " + str(startingDay)
	pass

func _on_Player_hunger():
	if startingHunger >= 100:
		emit_signal("hungerMaxed")
		return
	startingHunger+=20
	updateHunger()
	pass


func _on_Player_lifeDropped():
	if startingLife <= 0:
		emit_signal("lifeGone")
		return
	startingLife-=20
	life.text = "Life: " + str(startingLife)
	pass


func _on_Player_ateFood():
	if startingFood <= 0:
		return
	startingFood-=1
	
	if startingHunger > 0:
		startingHunger-=5
	food.text = "Food: " + str(startingFood)
	updateHunger()
	pass 

func updateHunger():
	hunger.text = "Hunger: " + str(startingHunger)
	pass