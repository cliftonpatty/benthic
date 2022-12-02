extends Node2D

@export var shape: Resource

@onready var baseBlock := $Grid/GridBlock

@onready var hand_open = preload("res://ui/elements/cursors/hand_open.png")
@onready var hand_closed = preload("res://ui/elements/cursors/hand_closed.png")

var drag_body
var recent_drag = null
var grid_size = Vector2( 10,8 )

#-------------------------------------------------------------------------------

func _ready() -> void:
	
	Input.set_custom_mouse_cursor(hand_open)
	
	var y_axis = 0
	
	#Make a test grid - just duplicating the base block 'GridBlock'
	for row in grid_size.y:
		
		var previousBLock = null
		
		for col in grid_size.x:
			
			var newBlock: Area2D = baseBlock.duplicate()
			if previousBLock:
				$Grid.add_child(newBlock)
				newBlock.global_position.x = previousBLock.global_position.x + 64
			else:
				$Grid.add_child(newBlock)
				newBlock.global_position.x = baseBlock.global_position.x + 64
	
			newBlock.global_position.y = baseBlock.global_position.y + y_axis
			
			previousBLock = newBlock
			
		y_axis += 64

	for meat_piece in $Meat.get_children():
		meat_piece.dragged.connect(get_dragged_meat)


#-------------------------------------------------------------------------------

func _physics_process(delta: float) -> void:

	if drag_body:
		
		#These few lines reset the grid state on pickup, it is stupid. It works.
		if drag_body.beingDragged == false:
			settle_grid(drag_body)
		drag_body.beingDragged = true
		
		drag_body.position = lerp( 
			drag_body.position, 
			get_global_mouse_position(), 
			25 * delta
			)
		recent_drag = drag_body
		Input.set_custom_mouse_cursor(hand_closed)
		
	
	#Find nearest grid block, only references the furthest BOTTOM LEFT grid space of the block, 
	#all others are 'implied' through code
	if drag_body == null and recent_drag:
		Input.set_custom_mouse_cursor(hand_open)
		#Irrellevant placeholder value
				
		var smallestDistance = 100
		var nearestPos = Vector2(100,-150)

		var detector = recent_drag.gridSettling
		
		if detector.has_overlapping_areas():
			print('Seeking Suitable Drop')
			for item in detector.get_overlapping_areas():
				if item.blockCovered:
					break
				var distance = recent_drag.global_position.distance_to(item.global_position)
				if distance < smallestDistance:
					smallestDistance = distance
					nearestPos = item.global_position
		else: 
			print('No drop found ---- Defaulting to global pos')
			nearestPos = Vector2(100,150)
		
		recent_drag.global_position = lerp( 
			recent_drag.position, 
			nearestPos, 
			25 * delta
			)
			
		if recent_drag.position.distance_to(nearestPos) < 0.002:
			settle_grid(drag_body)
			print('Starting Settle')
			recent_drag = null

#-------------------------------------------------------------------------------

#Cycle through Grid points after tetro is dropped and decide what is covered
func settle_grid(body):
	print('settling')
	for block in $Grid.get_children():
		block.blockCovered=false
	
	for chunk in $Meat.get_children():
		for grid in chunk.gridSettling.get_overlapping_areas():
			if grid.is_in_group('grid'):
				grid.blockCovered = true


#-------------------------------------------------------------------------------

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Rotate"):
		if drag_body:
			drag_body.rotation += PI/2

#-------------------------------------------------------------------------------

func get_dragged_meat(body, dragged) -> void:
	if dragged:
		drag_body = body
	else:
		drag_body = null

#-------------------------------------------------------------------------------

#WIPE MODULATED COLOR of Grid Collision boxes - not visible outside of debug
func wipe_grid():
	for block in $Grid.get_children():
		block.hover = false
