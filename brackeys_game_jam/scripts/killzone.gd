extends Area2D

@export_range(0.1, 5) var death_time: float = 0.1

@onready var timer: Timer = $Timer
@onready var death_sfx = $death_sound

func _ready() -> void:
	timer.wait_time = death_time

func _on_body_entered(_body: Node2D) -> void:
	death_sfx.play()
	#await death_sfx.finished
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
