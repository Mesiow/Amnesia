extends "res://Environment/Wildlife/Scripts/Animal.gd"

const DeerFootprint = preload("res://Environment/Wildlife/Scenes/DeerFootprint.tscn")

func _ready():
	spawn()
	pass

func _process(delta):
	if !feeding: #then the animal is moving
		if int(global_position.x) % 5 == 0:
			var footprint = DeerFootprint.instance()
			footprint.spawn(global_position, moveDir.angle())
			get_parent().add_child(footprint)
	pass