extends Node2D

@export var cloud_type: int = 0

@onready var cloud_1: Sprite2D = $Cloud1
@onready var cloud_2: Sprite2D = $Cloud2
@onready var cloud_3: Sprite2D = $Cloud3
@onready var cloud_4: Sprite2D = $Cloud4

func _ready() -> void:
	match cloud_type:
		
		0:
			print("No Cloud Sprite Selected")
		1:
			cloud_1.visible = true
		2:
			cloud_2.visible = true
		3:
			cloud_3.visible = true
		4:
			cloud_4.visible = true
