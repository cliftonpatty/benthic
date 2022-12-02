extends Area2D

var hover := false

var blockCovered: bool = false

@onready var colChild = $CollisionShape2D

func _physics_process(delta):
	$Label.text = str(blockCovered)
