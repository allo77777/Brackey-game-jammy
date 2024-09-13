extends CharacterBody2D
class_name Player

#Player movement
@export_category("Movement")
@export var SPEED: float = 220.0
@export var JUMP_VELOCITY: float = -500.0

@export_category("References")
@export var game: Node2D
@export var fallen_tree: StaticBody2D
@export var storm_fog: Sprite2D


#References
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_time: Timer = $Timers/CoyoteTime
@onready var jump_buffering: Timer = $Timers/JumpBuffering
@onready var interact_label: Label = $Interactions/InteractionArea/InteractLabel
@onready var calm_particles: GPUParticles2D = $CalmParticles
@onready var storm_particles: GPUParticles2D = $StormParticles
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var rain: ColorRect = $"../Rain"
#those play sounds 
@onready var jump_sfx = $jump_sound
#this is the delay death animation

#Variables
var facing: int
var direction: float
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity", 980)
var prevVelocity: Vector2
var all_interactions: Array = []


func _ready() -> void:
	update_interaction()
	calm_particles.show()
	storm_particles.hide()
	storm_fog.hide()
	rain.hide()
	
func _physics_process(delta: float) -> void:	
	
	facing_direction()
	
	#Jump buffering
	if is_on_floor() and jump_buffering.time_left > 0:
		jump()
		
	#Coyote time
	elif !is_on_floor() and coyote_time.time_left > 0 and Input.is_action_just_pressed("jump"):	
		jump()
		
	#Handle jump
	if Input.is_action_just_pressed("jump"):	
		jump_buffering.start()
	
		if is_on_floor():	
			jump()
		
	#Variable jump height
	elif Input.is_action_just_released("jump") and velocity.y < 0:
		#Y-axis movement
		velocity.y *= 0.4
		
	#While falling	
	elif not is_on_floor():
		#Y-axis movement
		velocity.y += gravity * delta
		
		#X-axis movement
		velocity.x = direction * SPEED
		velocity.x = lerp(prevVelocity.x, velocity.x, 0.1)	
		
	#Running
	else:
		coyote_time.start()
		
		if direction:
			#X-axis movement
			animated_sprite_2d.play("Run")
			velocity.x = direction * SPEED
			
			
		else:
			#X-axis movement
			animated_sprite_2d.play("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)		
			
	#Smoother Jump
	if abs(velocity.y) < 40 and velocity.y != 0:
		#Y-axis movement
		gravity *= 0.90
		
	else:
		#Y-axis movement
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity", 980)
		
	prevVelocity = velocity
		
	#---Storm---
	
	#Change player movement while storm is active
	if game.storm:
		velocity.x += game.wind_strength * game.wind_direction
		
	#---Interaction---
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
		
	move_and_slide()
	
func facing_direction():
	direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		facing = 1
		animated_sprite_2d.flip_h = false
		
	elif direction < 0:
		facing = -1
		animated_sprite_2d.flip_h = true
		
func jump():
	animated_sprite_2d.play("Jump")
	coyote_time.stop()
	
	velocity.y = JUMP_VELOCITY
	velocity.y = lerp(prevVelocity.y, velocity.y, 0.8)
	jump_sfx.play()

#Interaction
#---------------------------------------------------------------#

func _on_interaction_area_area_entered(area: Area2D) -> void:
	all_interactions.insert(0, area)
	update_interaction()

func _on_interaction_area_area_exited(area: Area2D) -> void:
	all_interactions.erase(area)
	update_interaction()
	
func update_interaction():
	if all_interactions:
		interact_label.text = all_interactions[0].interact_label
		
	else:
		interact_label.text = ""
		
func execute_interaction():
	if all_interactions:
		var current_interaction = all_interactions[0].interact_type
		
		match current_interaction:					
			0:
				if !game.storm:
					storm()
				
#Out Of Bounds
#---------------------------------------------------------------#
	
func storm():
	game.storm = true
	fallen_tree.queue_free()
	calm_particles.hide()
	storm_particles.show()
	storm_fog.show()
	point_light_2d.energy = 0.5
	rain.show()
