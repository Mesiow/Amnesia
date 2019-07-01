extends Node

onready var player = get_node("Player")

onready var mapSizeX = get_node("GeneratedMap").WORLD_SIZE_X
onready var mapSizeY = get_node("GeneratedMap").WORLD_SIZE_Y

const Restart = preload("res://World/Scenes/RestartScene.tscn")

func _ready():
	pass
	
func _process(delta):
	pass
	

func _on_Player_playerDied():
	var restart = Restart.instance()
	add_child(restart)
	pass
