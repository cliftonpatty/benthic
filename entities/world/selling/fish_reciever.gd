extends Node2D

@onready var world := $/root/World

@onready var eel = preload("res://Fish/Individual/eel.tscn")
@onready var blobfish = preload("res://Fish/Individual/blobfish.tscn")
@onready var greeny = preload("res://Fish/Individual/greeny.tscn")
@onready var redy = preload("res://Fish/Individual/redy.tscn")

func _ready() -> void:
	var fishBucket = Node2D.new()
	self.add_child(fishBucket)
	var newFish
	for fish in SceneSwap.scene_package:
		if fish == 'eel':
			newFish = eel.instantiate()
		elif fish == 'blobfish':
			newFish = blobfish.instantiate()
		elif fish == 'greeny':
			newFish = greeny.instantiate()
		elif fish == 'redy':
			newFish = redy.instantiate()
		else:
			print('SOMETHING WENT WRONG ON FISH CREATION')
			pass
		fishBucket.add_child(newFish)
