extends CanvasLayer


func _on_btn_exit_pressed() -> void:
	get_tree().quit()


func _on_btn_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_btn_return_pressed() -> void:
	self.hide()
	get_tree().paused = false
