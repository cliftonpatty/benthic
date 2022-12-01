extends Node

signal scene_changed()

var scene_package: Array = []

func handoff_package(contents: Array, path, delay = 1):
	for item in contents:
		scene_package.append(item.id)
	await get_tree().create_timer(delay).timeout
	assert( get_tree().change_scene_to_file(path) == OK )
	
func change_scene(path, delay = 0.5):
	await get_tree().create_timer(delay).timeout
	assert( get_tree().change_scene_to_file(path) == OK )
	
