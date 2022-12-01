extends RigidBody2D

@onready var sprite = $Sprite2D
@onready var animSprite: AnimatedSprite2D = $BloodSplat
@onready var area: Area2D = $Area2D
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var value := 150
@export var speed := 200
@export var caught := true
@export var id: String

signal add_me_to_fishingline( body )

var direction := -1

func _ready():
	# LEFT OR RIGHT?
	@warning_ignore(narrowing_conversion)
	direction = pow(-1, randi() % 2)

func _process(delta):
	if caught == false:
		position.x = position.x + ((speed * direction) * delta)
		
		
func _on_area_2d_body_entered(body):
	if body.collision_layer == 1:
		call_deferred("flip")
	if body.collision_layer == 2:
		if body.name == 'Player':
			if body.drilling == true:
				call_deferred('state_swap', false)
				sprite.visible = false
				animSprite.visible = true
				animSprite.play("default")
			else:
				call_deferred('state_swap')
	# A STUPID WAY TO MANAGE SPRITE ORIENTATION - kinda works for now.
	# Don't ask why it's not just in the flip() function. 
	if direction > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func flip():
	direction *= -1

#emit is true by defualt, but can be turned off it you only want to disable movement and processing
func state_swap(emit=true):
	#Disable all checks once caught
	area.monitoring = false
	area.monitorable = false
	collision.disabled = true
	caught = true
	set_physics_process(false)
	if emit:
		var emitError = emit_signal("add_me_to_fishingline", self)
		if emitError:
			print("FISH::Add_to_fishingline    ERRORCODE:", emitError)


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
