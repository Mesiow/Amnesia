extends Node2D

const dayMaxTime = 1000 #1 minute
const nightMaxTime = 1000 #1 minute

const dayTint=Color(232, 225, 225, 255)
const nightTint=Color(42, 42, 42, 255)
var currentTint = null

onready var dayNoise=$DayTimeAmbience
onready var cycle=$CanvasModulate/Cycle
onready var canvas=$CanvasModulate
#onready var firepitLight = get_parent().get_node("Firepit").get_node("Light")

var night = true
var day = false

func _ready():
	set_process(true)
	playDayAmbience()
	yield(get_tree().create_timer(20.0), "timeout")
	startNight()
	pass
	
func _process(delta):
	#if cycle.is_playing() and night:
	#	firepitLight.energy += 0.0001
	#elif cycle.is_playing() and day:
	#	firepitLight.energy -= 0.001
	pass
	
func startDay():
	cycle.play_backwards("NightTransition")
	day = true
	night = false
	playDayAmbience()
	pass
	
func startNight():
	cycle.play("NightTransition")
	night = true
	day = false
	pass

func _on_Cycle_animation_finished(anim_name):
	if anim_name == "NightTransition" and night:
		stopDayAmbience()
		#yield(get_tree().create_timer(3), "timeout") #wait 1 minute till day
		#startDay()
	#elif anim_name == "NightTransition" and day:
	#	yield(get_tree().create_timer(3), "timeout")
	#	startNight()
	pass
	
func playDayAmbience():
	dayNoise.play()
	if dayNoise.playing:
		for i in range(dayNoise.volume_db, -15): #raise volume slowly
			dayNoise.volume_db+=1
	pass
	
func stopDayAmbience():
	if dayNoise.playing:
		for i in range(dayNoise.volume_db, -80):
			dayNoise.volume_db -= 1
			
	dayNoise.stop()
	pass

