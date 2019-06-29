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

func _ready():
	life.text = life.text + str(startingLife)
	food.text = food.text + str(startingFood)
	days.text = days.text + str(startingDay)
	hunger.text = hunger.text + str(startingHunger)
	ammo.text = ammo.text + str(startingAmmo)
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
	startingHunger+=5
	hunger.text = "Hunger: " + str(startingHunger)
	pass
