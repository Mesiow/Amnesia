extends Node2D

onready var world = get_tree().get_root().get_node("/root/World")
onready var player=get_tree().get_root().get_node("/root/World/Player")

const Deer=preload("res://Environment/Wildlife/Scenes/Deer.tscn")

const maxGroupSize : int = 5

var animalRef = null

func _ready():
	pass
	
func _process(delta):
	randomize()
	var animalGroup = get_tree().get_nodes_in_group("Animal")
	if animalGroup.size() <= 0:
		spawnDeer(randi() %maxGroupSize + 0)
		get_tree().call_group("Animal", "setPlayer", player) #call group func and pass in player reference to the Animal setPlayer method so that the animal can reference the player

	handlePlayerAnimalInteraction(animalGroup)
	pass

func handlePlayerAnimalInteraction(animalGroup):
	if player:
		if player.hitTarget:
			if animalGroup.size() > 0:
				for animal in animalGroup:
					#if animalRef: break
					if player.closestAnimalDist > animal.distanceToPlayer: #if we shot at the closest deer, we got it
						if !animal.dead:
							animal.kill()
							animalRef = animal
							player.hitTarget = false
							break
		if animalRef and player.grabbedFood:
			animalRef.queue_free() #delete the animal because the player grabbed the food
			animalRef = null
			player.grabbedFood = false

		if animalRef:
			if animalRef.distanceToPlayer <= 20:
				player.nearKilledAnimal = true
			else:
				player.nearKilledAnimal = false
		else:
			player.nearKilledAnimal = false

	pass

func spawnDeer(amount):
	if amount <= 1:
		var deer = Deer.instance()
		add_child(deer)
		return
		
	for i in range(0, amount):
		var deer = Deer.instance()
		add_child(deer)
	pass