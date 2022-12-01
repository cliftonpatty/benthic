extends CharacterBody2D

#Effects and Sprites------------------------------------------------------------
@onready var bubbles = $Body/CPUParticles2D
@onready var sprite = $Body/Sprite2D
@onready var drillSplatter = $Body/Sprite2D/DrillSplatter

#UI Elements--------------------------------------------------------------------
@onready var depthLabel = $Depth

#Body and Collision-------------------------------------------------------------
@onready var body = $Body
@onready var collision: CollisionShape2D = $Collision

#World reference----------------------------------------------------------------
@onready var world = $/root/World

#The player doesn't actually move, so I'm doing this for now,
#This needs to be hooked up to a more 'global' value.. if not just a global value
var depth = 0
var statusText = 'Above Water'
const SPEED = 300.0
var drill_efficiency = 0.5

#THIS NEEDS TO BE A STATE MACHINE!!!!
var drilling = false

signal hit_a_fish( fishInfo ) 

func _ready():
	Globals.connect('hit_fish', Callable(self,'trigger_upward'))
	pass
	
func _physics_process(delta):
	var direction = Input.get_axis("LeftMove", "RightMove")
	
	if world.currentState == 1 or world.currentState == 2 and world.underwater:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		#This is movement, godot's generic 'send body around' function
		#It returns a bool if the body collided with something - which I'm not using
		var _collisionDetected = move_and_slide()
	
	else:
		position = lerp( position, world.get_node("/root/World/Claw").global_position, 4 * delta )
		body.rotation = lerp_sprite(0, delta)
		
	if velocity.x > 0 and world.currentState == 1:
		body.rotation = lerp_sprite(-0.5, delta)
	elif velocity.x < 0 and world.currentState == 1:
		body.rotation = lerp_sprite(0.5, delta)
	elif velocity.x > 0 and world.currentState >= 2:
		body.rotation = lerp_sprite(0.5, delta)
	elif velocity.x < 0 and world.currentState >= 2:
		body.rotation = lerp_sprite(-0.5, delta)
	else:
		body.rotation = lerp_sprite(0, delta)
	
	#Update depth... not real depth, given the player's ability to move horizontally
	#Need to fix - works for now
	if world.underwater:
		depth -= int(Globals.dropSpeed * delta)
	depthLabel.text = str(int(depth/30.0)*-1, " ft")

	if world.currentState >= 2:
		sprite.flip_v = true
		drillSplatter.flip_v = true
		drillSplatter.offset.y = -380.0
		collision.shape.height = 56
		collision.shape.radius = 19
	else:
		sprite.flip_v = false
		drillSplatter.flip_v = false
		drillSplatter.offset.y = 0
		collision.shape.height = 38
		collision.shape.radius = 13

	#Deduct gas if drilling
	if drilling:
		world.gas_level -= drill_efficiency
		if world.gas_level <= 0:
			drill_trigger(false)

#Smooth rotation on movement 
func lerp_sprite( target, delta ):
	return lerp_angle( body.rotation, target, ( 10 * delta) )
	
func trigger_upward():
	world.change_state(2)

func trigger_underwater(underwater) -> void:
	if underwater:
		statusText = 'Above Water'
		bubbles.visible = false
	else:
		bubbles.visible = true
		bubbles.emitting = true
		statusText = 'Diving'

#Set 'game end' on collision with claw
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == 'ClawDetect' and world.currentState == 2:
		world.change_state(3)
		
#If attacking, activate drill 
func _input(event: InputEvent) -> void:
	if world.gas_level > 0:
		if event.is_action_pressed("Attack"):
			drill_trigger(true)
		if event.is_action_released("Attack"):
			drill_trigger(false)

func drill_trigger(val) -> void:
	var drill_speed_alteration = 1.5
	drilling = val
	drillSplatter.visible = val
	if val:
		Globals.dropSpeed = Globals.dropSpeed * drill_speed_alteration
	else:
		Globals.dropSpeed = Globals.dropSpeed / drill_speed_alteration
