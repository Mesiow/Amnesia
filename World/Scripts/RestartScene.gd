extends CanvasLayer



func _on_ExitBtn_pressed() -> void:
	get_tree().quit()
	pass 


func _on_RestartBtn_pressed() -> void:
	get_tree().reload_current_scene()
	pass 
