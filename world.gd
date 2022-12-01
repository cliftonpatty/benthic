extends Node2D

#UI SHIT------------------------------------------------------------------------
@onready var camera := $Camera2D
@onready var label := $Camera2D/UI/Label
@onready var debug: RichTextLabel = $Camera2D/UI/Debug
@onready var gas_tank = $Camera2D/UI/GasTank
@onready var button: Button = $Camera2D/UI/Button
@onready var nextScene: Button = $Camera2D/UI/NextScene

#PLAYER & CLAW------------------------------------------------------------------
@onready var player := $Player
@onready var claw := $Claw
@onready var gas_level = gas_tank.gas_max

#FISH THAT HAVE BEEN CAUGHT-----------------------------------------------------
@onready var caughtFish := $CaughtFish

#Node References----------------------------------------------------------------
@onready var surfaceDetect := $SurfaceDetector

var falling: bool = true
var underwater: bool = false
var dropped: bool = false

enum {
	PRE,
	FALLING,
	CLIMBING,
	POST
	}
	
@onready var currentState = PRE

func _ready() -> void:
	Globals.connect('hit_fish', Callable(self, 'hit_a_fish'))
	surfaceDetect.body_entered.connect(trigger_underwater)

func _physics_process(delta):
	gas_tank.current_gas = gas_level
	label.text = str("Current State: ", currentState)
	label.text += str("\nUnderwater: ", underwater)
	
	var debugList: Array
	for fish in caughtFish.caughtFish:
		debugList.append(fish.id)
	debug.text = str(debugList)
	
	#PROCESS
	if Input.is_action_just_pressed("HitBottom"):
		Globals.dropSpeed = Globals.dropSpeed * -1
		change_state(CLIMBING)

	#World State swapping, updates the camera position and claw position 
	match currentState:
		PRE:
			Globals.dropSpeed = abs(Globals.dropSpeed)
			camera.position.x = lerp(camera.position.x, player.position.x, 2 * delta)
			camera.position.y = lerp(camera.position.y, get_viewport().get_visible_rect().size.y * .2, 2 * delta)
		FALLING:
			claw.position.y -= int(Globals.dropSpeed * delta)
			camera.position.x = lerp(camera.position.x, player.position.x, 2 * delta)
			camera.position.y = lerp(camera.position.y, get_viewport().get_visible_rect().size.y * .3, 2 * delta)
		CLIMBING:
			claw.position.y -= int(Globals.dropSpeed * delta)
			camera.position.x = lerp(camera.position.x, player.position.x, 2 * delta)
			camera.position.y = lerp(camera.position.y, get_viewport().get_visible_rect().size.y * -.1, 2 * delta)
		POST:
			camera.position.x = lerp(camera.position.x, player.position.x, 4 * delta)
			camera.position.y = lerp(camera.position.y, player.position.y, 4 * delta)

#World State swapping - externally
func change_state(state):
	currentState = state
	
#Emitted function, from globals------------------------------------------------
func hit_a_fish():
	if currentState == FALLING:
		currentState = CLIMBING
		Globals.dropSpeed = Globals.dropSpeed * -1

func _on_button_button_down() -> void:
	change_state(FALLING)
	button.disabled = true

func _on_next_scene_button_down() -> void:
	var package: Array
	for fish in caughtFish.caughtFish:
		package.append(fish)
	SceneSwap.handoff_package(package, "res://TradeTown/trade_town.tscn")
	
#Trigger and toggle the 'underwater' condition/state
func trigger_underwater(body) -> void:
	print(body)
	underwater = !underwater
	player.trigger_underwater(underwater)
