extends Sprite

signal spawned

func spawn(pos, angle):
	global_position = pos
	rotation = -angle
	emit_signal("spawned")
	pass
