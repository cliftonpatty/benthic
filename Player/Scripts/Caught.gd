extends RigidBody2D


func _process(delta):
	var par = get_parent()
	global_position = lerp(global_position, Vector2(par.position.x, par.position.y + 100), .1 * delta)
