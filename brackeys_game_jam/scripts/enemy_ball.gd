extends CharacterBody2D

# i hate this dont use this fuck this
var speed = 120
@onready var player:CharacterBody2D = %player

func _ready():
	self.visible = false

func get_to_player():
	var player_position = player.position
	var direction = (player_position - position).normalized()
	velocity = direction * speed


func _physics_process(delta):
	if self.visible == true:
		get_to_player()
		move_and_slide()
