extends StaticBody2D

#Refrences
@export var game: Node2D
@onready var animation_player: AnimationPlayer = $Artifact/AnimationPlayer
@onready var artifact: Sprite2D = $Artifact

func _ready() -> void:
	animation_player.play("ArtifactSway")
	
func _process(_delta: float) -> void:
	if game.storm:
		artifact.visible = false
		animation_player.stop()
