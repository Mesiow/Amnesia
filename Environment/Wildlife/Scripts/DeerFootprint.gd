extends "res://Environment/Wildlife/Scripts/Footprint.gd"

func _on_DeerFootprint_spawned():
	$Anim.play("fade")
	pass 

func _on_Anim_animation_finished(anim_name):
	if anim_name == "fade":
		queue_free()
	pass
