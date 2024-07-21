extends Entity
class_name Player

#actions
var moving: bool
var jumping: bool

#action timers
var moving_timer: Timer
var attack_timer: Timer

#player stats
var player_attack: int = 10
var player_quick: int = 10
var player_normal: int = 30
var player_power: int = 50
var player_max_health: int = 100
var player_health: int
var player_defense: int = 10

@onready var player_animation: AnimationPlayer = $AnimationPlayer

@onready var UI: Node2D = $UI
@onready var UI_forward: Control = $UI/ForwardControl

var move_distance: float = 120
var move_time: float = 1
var jump_height: float = 100
var jump_time: float = 0.5

var move_speed: float
var move_acceleration: float
var jump_speed: float
var jump_acceleration: float

var target_velocity: Vector2 = Vector2.ZERO

func on_active():
	player_animation.play("idle")
	UI.visible = true
	if close_range:
		UI_forward.visible = false

func off_active():
	UI.visible = false
	moving = false
	jumping = false
	player_animation.play("idle")

func _ready():
	#setting up the action timers
	moving_timer = $MovingTimer as Timer
	moving_timer.wait_time = move_time
	
	#setting up the stats
	attack = player_attack
	quick_attack = player_quick
	normal_attack = player_normal
	power_attack = player_power
	max_health = player_max_health
	current_health = player_health
	current_health = max_health
	defense = player_defense
	
	move_speed = (2 * move_distance) / (move_time)
	move_acceleration = (2 * move_distance) / (move_time * move_time) #acceleration is negative but we want the module
	
	jump_speed = (-2 * jump_height) / (jump_time)
	jump_acceleration = (2 * jump_height) / (jump_time * jump_time)
	
	player_animation.play("idle")

func _physics_process(delta):
	#x axis movement
	if moving:
		target_velocity = target_velocity.move_toward(Vector2.ZERO, move_acceleration * delta)
	
	velocity.x = target_velocity.x
	
	#y axis movement
	if jumping:
		velocity.y += jump_acceleration * delta
	
	move_and_slide()

func action_timer(timer: Timer):
	timer.start()

#BUTTONS
func _on_move_forward_pressed():
	#move forward button pressed
	action_timer(moving_timer)
	moving = true
	UI.visible = false
	target_velocity = Vector2.RIGHT * move_speed

func _on_move_backwards_pressed():
	action_timer(moving_timer)
	moving = true
	UI.visible = false
	target_velocity = Vector2.LEFT * move_speed

func _on_jump_forward_pressed():
	action_timer(moving_timer)
	moving = true
	jumping = true
	UI.visible = false
	target_velocity = Vector2.RIGHT * move_speed
	velocity.y = jump_speed
	player_animation.play("Jump")
	
func _on_jump_backwards_pressed():
	action_timer(moving_timer)
	moving = true
	jumping = true
	UI.visible = false
	target_velocity = Vector2.LEFT * move_speed
	velocity.y = jump_speed
	player_animation.play("Jump")

func _on_charge_pressed():
	action_timer(moving_timer)
	moving = true
	UI.visible = false
	target_velocity = Vector2.RIGHT * move_speed
	player_animation.play("charge")

func _on_low_kick_pressed():
	UI.visible = false
	player_animation.play("low_kick")
	await player_animation.animation_finished
	Attack.emit(self, quick_attack)

func _on_straight_punch_pressed():
	UI.visible = false
	player_animation.play("punch")
	await player_animation.animation_finished
	Attack.emit(self, normal_attack)

func _on_high_kick_pressed():
	UI.visible = false
	player_animation.play("head_kick")
	await player_animation.animation_finished
	Attack.emit(self, power_attack)


#SIGNALS
	#must have a timer called MovingTimer

func _on_moving_timer_timeout():
	PlayTurned.emit(self)

func _on_attack_area_body_entered(_body):
	#must have an area2D called AttackArea
	close_range = true

func _on_attack_area_body_exited(_body):
	#must have an area2D called AttackArea
	close_range = false
	UI_forward.visible = true


