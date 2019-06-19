extends Node2D

const dayMaxTime = 1000 #1 minute
const nightMaxTime = 1000 #1 minute

onready var cycle=$CanvasLayer/Cycle
onready var firepitLight =get_parent().get_node("Firepit").get_node("Light")

var night = true
var day = false

func _ready():
	set_process(true)
	
	cycle.play("NightTransition")
	night = true
	pass
	
func _process(delta):
	if cycle.is_playing() and night:
		firepitLight.energy += 0.0001
	elif cycle.is_playing() and day:
		firepitLight.energy -= 0.001
	pass
	
func startDay():
	cycle.play_backwards("NightTransition")
	day = true
	night = false
	pass

func _on_Cycle_animation_finished(anim_name):
	if anim_name == "NightTransition":
		yield(get_tree().create_timer(3), "timeout") #wait 1 minute till day
		startDay()
	pass

