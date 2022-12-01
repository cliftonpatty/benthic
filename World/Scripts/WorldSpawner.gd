extends Node2D

@onready var main = get_tree().current_scene

const wallChunk = preload("res://World/WorldChunk.tscn")
const caveBkg = preload("res://World/cave_background.tscn")

var bkgRef
var newColor = Color(0.8,0.86,1,1)
var spawn_count = 0

func _ready():
	call_deferred("add_baby")
	call_deferred("make_background")
	
func make_background():
	var bkg = caveBkg.instantiate() 
	main.add_child(bkg)
	bkg.global_position = global_position
	bkgRef = bkg
	
func add_baby():
	var inst = wallChunk.instantiate()
	main.add_child(inst)
	inst.global_position = global_position
	var new_inst = inst.connect("trigger_entered", Callable(self, "_child_Trigger_Entered"))
	spawn_count += 1
	if bkgRef:
		var color = Color(bkgRef.background_color.color)
		newColor = color.darkened(.1) 
		
	else:
		print('no background')
	
func _child_Trigger_Entered():
	call_deferred("add_baby")
	
func _physics_process(delta):
	#PROCESS
	if bkgRef:
		var color = Color(bkgRef.background_color.color)
		bkgRef.background_color.set_color( lerp(color, newColor, delta) )    
