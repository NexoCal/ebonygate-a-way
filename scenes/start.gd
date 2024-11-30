extends CanvasLayer


signal startGame




func _on_button_pressed() -> void:
	startGame.emit()
	
