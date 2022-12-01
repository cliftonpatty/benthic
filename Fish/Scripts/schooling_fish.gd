extends Node2D

#WIP, just messing around with paths... probably not the ideal solution for schooling behavior 

var items: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in $Fish.get_children():
		var fishObj = {
			'fish' : item,
			'offset' : randi_range( -100, 100 ),
			'time' : randi_range( 1, 100 )
		}
		items.append(fishObj)
	print(items)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Path2D/PathFollow2D.progress_ratio += (.5 * delta)
	for item in items:
		item.fish.position.y = lerp( item.fish.position.y - item.offset, $Path2D/PathFollow2D.position.y, item.time * delta )
		item.fish.position.x = lerp( item.fish.position.x, $Path2D/PathFollow2D.position.x, item.time * delta )
