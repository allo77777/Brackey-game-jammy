extends Node2D

@export var game: Node2D
@export var player: CharacterBody2D

@onready var timer: Timer = $Timer
@onready var lightning_sprite: AnimatedSprite2D = $LightningSprite
@onready var warning_sprite: Node2D = $WarningSprite
@onready var killzone: Area2D = $Killzone
@onready var sound_timer: Timer = $SoundTimer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var delay_timer: Timer = $DelayTimer
@onready var point_light_2d: PointLight2D = $PointLight2D

var lightning_origin = 0

func _ready() -> void:
	warning_sprite.hide()
	lightning_sprite.hide()
	point_light_2d.hide()
	killzone.monitoring = false
	
func _process(_delta: float) -> void:
	if game.storm:
		lightning_origin = player.position
		
func _on_animated_sprite_2d_animation_finished() -> void:
	#Turn off lightning
	point_light_2d.hide()
	lightning_sprite.hide()
	killzone.monitoring = false
		
func _on_timer_timeout() -> void:
	#Every random amout of tiem this timer triggers
	if game.storm:
		global_position.x = randi_range(lightning_origin.x - 300, lightning_origin.x + 300)
		global_position.y = lightning_origin.y - 50
		timer.wait_time = randf_range(0.5, 4)
		timer.stop() #Stops the random timer
		
		delay_timer.start()	#Starts the delay timer
		
		warning_sprite.show()
		
func _on_delay_timer_timeout() -> void:
	if game.storm:
		#Turn on lightning
		lightning_sprite.show()
		point_light_2d.show()		
		killzone.monitoring = true
		lightning_sprite.play("default")
		
		#Restart random timer
		timer.start()		
		
		#Warning
		warning_sprite.hide()
		#playtester huge W didn't liked delay so removed it 
		#SFX

		sound_timer.wait_time = 0.1
		sound_timer.start()
		
#Plays the thunder sound after a random time
func _on_sound_timer_timeout() -> void:
	print("thunder")
	audio_stream_player_2d.play()
	# ^^^^^^^^^^^^^^^^^^^^^^^^^
	#Add audio to audio stream player and uncomment the above line
	#You might have to tweak the code, I never expiremented with sound
	
