extends Node2D

@onready var chunks = $Chunks
@onready var fishline = $FishLine

var player: CharacterBody2D
var caughtFish: Array = []
var random_num = RandomNumberGenerator.new()
var lerpWeight := 6.0
var baseIncr := 5.0

var arcStart := ((baseIncr * baseIncr)/2)*-1

func _ready() -> void:
	if get_node( "/root/World/Player" ):
		player = get_node( "/root/World/Player" )
		
	#Connect to Global signal that player has hit a fish------------------------
	var transferError = Globals.connect(
		'globals_transfer_fish', Callable(self, "hit_a_fish")
		)
	if transferError:
		print("CAUGHT_FISH::Transfer Error    CODE:", transferError)
		
	var runCount =  ceil((len(fishline.get_children())/baseIncr))
	var subRunCount = 0
	for run in runCount:
		
		var newNode = makeNewNode(run)
		var arcPosition = arcStart
		
		for i in baseIncr: 
			if fishline.get_child(subRunCount):
				var workingFish = fishline.get_child(subRunCount).duplicate()
				newNode.add_child(workingFish)
				workingFish.rotation = deg_to_rad(arcPosition)
				subRunCount += 1
				arcPosition += ((arcStart*-1)/baseIncr)
			else:
				break

func _physics_process(delta):
	var goalPos = player.position
	var from = rotation
	for chunk in chunks.get_children():
		var myDex = chunk.get_index()
		
		if myDex > 0:
			chunk.global_position.x = lerp( 
				chunk.global_position.x, 
				chunks.get_child(myDex-1).global_position.x, 
				10 * delta 
				)
			chunk.global_position.y = lerp( 
				chunk.global_position.y, 
				chunks.get_child(myDex-1).global_position.y + (myDex + 30), 
				10 * delta 
				)
			chunk.rotation = lerp_angle(
				chunk.rotation, 
				chunks.get_child(myDex-1).rotation, 
				10 * delta
				)
		else:
			chunk.global_position.x = lerp( 
				chunk.global_position.x, 
				goalPos.x, 
				10 * delta 
				)
			chunk.global_position.y = lerp( 
				chunk.global_position.y, 
				goalPos.y + 30, 
				10 * delta 
				)
			chunk.rotation = lerp_angle(
				chunk.rotation, 
				deg_to_rad(player.get_real_velocity().x)/8, 
				10 * delta
				)

#RECIEVED FROM EMITTER - in global, originating from all fish-------------------
func hit_a_fish(fish: RigidBody2D):
	caughtFish.append(fish)
	if fish.get_parent() != null:
		var parentToKill = fish.get_parent()
		parentToKill.remove_child(fish)
		new_fish(fish)
	else:
		pass

#Find a node with room for fish, node being another 'bunch' of fish in the line-
func findWorkingNode():
	if chunks.get_child_count() > 0:
		var lastChunk = chunks.get_child(chunks.get_child_count()-1)
		if lastChunk.get_child_count() < 5:
			return lastChunk
		else:
			var newNode = makeNewNode(chunks.get_child_count())
			return newNode
	else:
		var newNode = makeNewNode(chunks.get_child_count())
		return newNode

#Make a new node, node being a 'bunch', if needed-------------------------------
func makeNewNode(dex):
	var newNode = Node2D.new()
	chunks.add_child(newNode)
	newNode.name = 'FishHunk' + str(dex)
	newNode.position.y = dex * 25 
	return newNode
	
#Add our fish to the bunch of fish----------------------------------------------
func new_fish(newFish):
	var foundNode = findWorkingNode()
	var arcPosition = arcStart + (baseIncr * foundNode.get_child_count())
	if newFish.get_parent() == null:
		foundNode.add_child(newFish)
		newFish.global_position = foundNode.global_position
		newFish.rotation = deg_to_rad((arcPosition * 4) - 90)


