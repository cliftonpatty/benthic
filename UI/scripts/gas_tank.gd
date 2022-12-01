extends Control

var current_gas: float = 0
@export var gas_max: float = 124

@onready var gas_level: ColorRect = $GasLevel

func _ready() -> void:
	current_gas = gas_max

func _physics_process(delta: float) -> void:
	gas_level.size.y = current_gas
