extends Node2D

@export_category("Storm Config")
@export var storm: bool = false
@export var wind_direction: int = 1
@export var wind_strength: int = 75

#References
@onready var fallen_tree: StaticBody2D = $Objects/FallenTree
@onready var directional_light_2d: DirectionalLight2D = $Light/DirectionalLight2D
@onready var end_goal = $end_goal



func _ready() -> void:
	directional_light_2d.show()
	

	
	
func _process(_delta: float) -> void:
	if storm == true:
		pass
		
		


func _on_end_goal_body_entered(body):
	if storm == true:
		get_tree().change_scene_to_file("res://scenes/menu_scenes/win_menu.tscn")
