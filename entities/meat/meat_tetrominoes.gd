extends Node2D

@export var originalValue: int = 500
var value: int

#Where we are getting our bonuses/buffs from... relevant in the 'get_bonus' func
var gotBonus = []

#These check which grid points are being overlapped on drop (and a static int of how many grid blocks this item covers)

@onready var gridSettling = $GridSettling
@onready var gridCoverage = 4
@onready var gridDetection = $GridDetection
@onready var bonusDetection = $BonusDetection

@onready var startingPos: Vector2
@onready var beingDragged: bool = false
@onready var meatSprite : Sprite2D = $MeatSprite

signal dragged( body, dragged )

#Likely the eventual generation method... can't decide
var grid_vectors = [
	[1,1,0,0],
	[1,0,0,0],
	[1,0,0,0],
	[0,0,0,0]
]

var mouse_in: bool = false

func _ready() -> void:
	value = originalValue
	startingPos = self.global_position

func _physics_process(delta: float) -> void:
	
	$Label.text = str('$',value)
	#This is just for debugging, no need to keep
	if beingDragged:
		$MouseDetection.modulate = '#fff'
	else:
		$MouseDetection.modulate = '#000'

func _on_mouse_detection_mouse_entered() -> void:
	mouse_in = true

func _on_mouse_detection_mouse_exited() -> void:
	mouse_in = false
	
func _on_mouse_detection_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("MouseDown") and mouse_in:
		emit_signal("dragged", self, true)
		z_index = 2
	if event.is_action_released("MouseDown"):
		beingDragged = false
		emit_signal("dragged", self, false)
		z_index = 1

func settle_bonus():
	if gridCoverage == len(gridSettling.get_overlapping_areas()):
		print(gridSettling.get_overlapping_areas())
