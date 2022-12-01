extends Area2D

var hover := false

var blockCovered: bool = false

@onready var colChild = $CollisionShape2D
