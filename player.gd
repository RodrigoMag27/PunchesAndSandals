extends Entity
class_name Player

#actions
var moving: bool
var jumping: bool

#action timers
var moving_timer: Timer
var jumping_timer: Timer
var attack_timer: Timer

#player stats
var player_attack: int = 10
var player_quick: int = 10
var player_normal: int = 30
var player_power: int = 50
var player_max_health: int = 100
var player_health: int
var player_defense: int = 10

var close_range: bool = false

var player_animation: AnimationPlayer

var UI: Node2D
var UI_forward: Control

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
	moving_timer.wait_time = jump_time
	
	#setting up the stats
	attack = player_attack
	quick_attack = player_quick
	normal_attack = player_normal
	power_attack = player_power
	max_health = player_max_health
	current_health = player_health
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
	action_timer(jumping_timer)
	moving = true
	jumping = true
	UI.visible = false
	target_velocity = Vector2.RIGHT * move_speed
	velocity.y = jump_speed
	player_animation.play("jump")

func _on_jump_bacwards_pressed():
	action_timer(moving_timer)
	moving = true
	jumping = true
	UI.visible = false
	target_velocity = Vector2.LEFT * move_speed
	velocity.y = jump_speed
	player_animation.play("jump")

func _on_charge_pressed():
	action_timer(moving_timer)
	moving = true
	UI.visible = false
	target_velocity = Vector2.RIGHT * move_speed
	player_animation.play("charge")

func _on_low_kick_pressed():
	UI.visible = false
	player_animation.play("low_kick")
	Attack.emit(self, quick_attack)

func _on_straight_punch_pressed():
	UI.visible = false
	player_animation.play("punch")
	Attack.emit(self, normal_attack)

func _on_high_kick_pressed():
	UI.visible = false
	player_animation.play("head_kick")
	Attack.emit(self, power_attack)


#SIGNALS
func _on_moving_timer_timeout():
	#must have a timer called MovingTimer
	PlayTurned.emit(self)

func _on_attack_area_body_entered(_body):
	#must have an area2D called AttackArea
	close_range = true

func _on_attack_area_body_exited(_body):
	close_range = false
