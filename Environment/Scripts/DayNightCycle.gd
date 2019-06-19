extends Node2D

const dayMaxTime = 1000 #1 minute
const nightMaxTime = 1 #1 minute

onready var cycle=$CanvasLayer/Cycle

var played = false

func _ready():
	set_process(true)
	pass
	
func _process(delta):
	if OS.get_ticks_msec() >= dayMaxTime:
		if !played:
			cycle.play("NightTransition")
			played = true
	pass
	
