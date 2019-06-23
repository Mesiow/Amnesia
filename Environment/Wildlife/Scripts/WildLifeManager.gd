extends Node2D

onready var world = get_tree().get_root().get_node("/root/World")
onready var player=get_tree().get_root().get_node("/root/World/Player")

const Deer=preload("res://Environment/Wildlife/Scenes/Deer.tscn")

func _ready():
	if world:
		spawnDeer(3)
		get_tree().call_group("Deer", "setPlayer", player) #call group func and pass in player reference to the Animal setPlayer method
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