extends Node2D

@export_category("Storm Config")
@export var storm: bool = false
@export var wind_direction: int = 1
@export var wind_strength: int = 50

#References
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

func _process(_delta: float) -> void:
	if storm:
		canvas_modulate.visible = true
		
