extends Node2D

const dayMaxTime = 1000 #1 minute
const nightMaxTime = 1000 #1 minute

const dayTint=Color(232, 225, 225, 255)
const nightTint=Color(42, 42, 42, 255)
var currentTint = null

onready var dayTimer=$DayTimer
onready var nightTimer=$NightTimer

onready var dayNoise=$DayTimeAmbience
onready var nightNoise=$NightTimeAmbience
onready var cycle=$CanvasModulate/Cycle
onready var canvas=$CanvasModulate
#onready var firepitLight = get_parent().get_node("Firepit").get_node("Light")

enum time{DAY = 0, NIGHT}
var currentTime = null

func _ready():
	dayTimer.wait_time = 300 #5 minutes
	nightTimer.wait_time = 300
	
	currentTime = time.DAY
	playAmbience(currentTime)
	
	dayTimer.start() # begin night timer
	pass
	
func _process(delta):
	pass
	
func startDay():
	cycle.play_backwards("NightTransition")
	currentTime = time.DAY
	playAmbience(currentTime)
	pass
	
func startNight():
	cycle.play("NightTransition")
	currentTime = time.NIGHT
	pass

func _on_Cycle_animation_finished(anim_name):
	if anim_name == "NightTransition" and currentTime == time.NIGHT:
		stopAmbience(time.DAY)
		playAmbience(currentTime)
		nightTimer.start() #if it was night countdown night timer 
	elif anim_name == "NightTransition" and currentTime == time.DAY:
		stopAmbience(time.NIGHT)
		playAmbience(currentTime)
		dayTimer.start()
	pass
	
func playAmbience(time):
	match time:
		0:
			dayNoise.play()
			if dayNoise.playing:
				for i in range(dayNoise.volume_db, -15): #raise volume slowly
					dayNoise.volume_db+=1
		1:
				nightNoise.play()
				if nightNoise.playing:
					for i in range(nightNoise.volume_db, -15): #raise volume slowly
						nightNoise.volume_db+=1
	pass
	
func stopAmbience(time):
	match time:
		0: dayNoise.stop()
		1: nightNoise.stop()
	pass

func _on_DayTimer_timeout():
	startNight()
	dayTimer.stop()
	pass


func _on_NightTimer_timeout():
	startDay()
	nightTimer.stop()
	pass
