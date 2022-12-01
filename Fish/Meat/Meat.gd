extends Node2D

signal dragged( body, dragged )

var mouse_in: bool = false

func _on_mouse_detect_mouse_entered() -> void:
	mouse_in = true
	
func _on_mouse_detect_mouse_exited() -> void:
	mouse_in = false
	
func _on_mouse_detect_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("MouseDown") and mouse_in:
		emit_signal("dragged", self, true)
	if event.is_action_released("MouseDown"):
		emit_signal("dragged", self, false)
