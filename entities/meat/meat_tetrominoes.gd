extends Node2D

#These will be, SHOULD BE, automated
#These check which grid points are being overlapped on drop (and a static int of how many grid blocks this item covers)
@onready var gridSettling = $GridSettling
@onready var gridCoverage = 4
@onready var gridDetection = $GridDetection

signal dragged( body, dragged )

#Likely the eventual generation method... can't decide
var grid_vectors = [
	[1,1,0,0],
	[1,0,0,0],
	[1,0,0,0],
	[0,0,0,0]
]

var mouse_in: bool = false

func _on_mouse_detection_mouse_entered() -> void:
	mouse_in = true

func _on_mouse_detection_mouse_exited() -> void:
	mouse_in = false
	
func _on_mouse_detection_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("MouseDown") and mouse_in:
		emit_signal("dragged", self, true)
	if event.is_action_released("MouseDown"):
		emit_signal("dragged", self, false)
