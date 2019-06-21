extends Area2D

#base class

export var speed = 150
export var velocity=Vector2()

onready var animalPath=$AnimalPath/AnimalPathFollow

func _ready():
	randomize()
	animalPath.set_offset(randi()) #set to random pos on the path
	position = animalPath.position #set animals position to that offset
	pass
