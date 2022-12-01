extends Node2D

@onready var background_color = $Polygon2D
@onready var world = $/root/World

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if world.currentState == 2 or world.currentState == 1:
		if position.y > 0:
			position.y -= int(Globals.dropSpeed * delta)
		else:
			pass
