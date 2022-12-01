extends Node

@export var dropSpeed: int = 500

signal globals_transfer_fish(body)
signal hit_fish

func hit_a_fish(body):
	var trigger = emit_signal("hit_fish")
	if trigger:
		print("GLOBALS::HIT_FISH ERROR    CODE:", trigger)
	var send = emit_signal("globals_transfer_fish", body)
	if send:
		print("GLOBALS::SEND_FISH ERROR    CODE:", send)
