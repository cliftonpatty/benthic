extends Node2D

@onready var world = $/root/World

func _process(delta):
	if world.currentState == 2 or world.currentState == 1:
		position.y = position.y - int(Globals.dropSpeed * delta)

