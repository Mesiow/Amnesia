extends Node2D

onready var world = get_tree().get_root().get_node("/root/World")
onready var player=get_tree().get_root().get_node("/root/World/Player")

const Deer=preload("res://Environment/Wildlife/Scenes/Deer.tscn")

const maxGroupSize = 4

func _ready():
	pass
	
func _process(delta):
	randomize()
	var animalGroup = get_tree().get_nodes_in_group("Animal")
	if animalGroup.size() <= 0:
		spawnDeer(randi() %maxGroupSize + 0)
		get_tree().call_group("Animal", "setPlayer", player) #call group func and pass in player reference to the Animal setPlayer method

	if player:
		if player.hitTarget:
			for animal in animalGroup:
				print("Player closest dist to animal: " + str(player.closestAnimalDist))
				if player.closestAnimalDist >= animal.distanceToPlayer: #if we shot at the closest deer we got it
					if !animal.dead:
						animal.kill()
						player.hitTarget = false
						return
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