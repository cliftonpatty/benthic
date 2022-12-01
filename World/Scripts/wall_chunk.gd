extends Node2D

@onready var world := $/root/World

signal trigger_entered

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if world.currentState == 2 or world.currentState == 1:
		position.y = position.y - int(Globals.dropSpeed * delta)

func _ready():
	pass

func _on_visible_on_screen_notifier_2d_screen_entered():
	var sig = emit_signal("trigger_entered")
