extends Area2D

@export var fish: Array[PackedScene] = []
@export var spawnAmount: int = 15

@onready var spawnBox = $CollisionShape2D
@onready var parent = self.get_parent()

var random_num = RandomNumberGenerator.new()

var yIncremint := 10

# Called when the node enters the scene tree for the first time.
func _ready():
	yIncremint = spawnBox.shape.size.y / spawnAmount
	var yPos = global_position.y
	for i in spawnAmount:
		make_a_fish(yPos)
		yPos += yIncremint

func _process(delta):
	pass

func make_a_fish(yPos):
	
	#Using all this excessive randoming to bypass the seed-based psuedo-random that GoDot uses
	#Remove randomize and random_num to generate 'random' numbers that stay static past first launch
	random_num.randomize()
	var dex = random_num.randi_range( 0, fish.size()-1 )
	var nFish = fish[dex].instantiate()
	nFish.connect("add_me_to_fishingline", Callable(Globals, 'hit_a_fish'))
	
	#Give the X-axis spawn some variance
	var xVar = random_num.randi_range( -200, 200 )
	
	#Spawn fish, call is deferred to not clog things up since this runs on 'ready'
	parent.call_deferred("add_child", nFish)

	nFish.global_position = Vector2(global_position.x + xVar, yPos)
	nFish.caught = false
