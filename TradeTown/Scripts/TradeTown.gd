extends Node2D

@onready var label = $RichTextLabel

func _ready() -> void:
	label.text = str(SceneSwap.scene_package)
	
func _on_button_button_down() -> void:
	SceneSwap.change_scene( "res://world.tscn" )
