extends Node

onready var mapSizeX = get_node("GeneratedMap").WORLD_SIZE_X
onready var mapSizeY = get_node("GeneratedMap").WORLD_SIZE_Y

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	pass
	