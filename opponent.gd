extends Entity
class_name opponent

#actions
var moving: bool
var jumping: bool

#action timers
var moving_timer: Timer

#opponent stats
var opponent_attack: int = 10
var opponent_quick: int = 10
var opponent_normal: int = 30
var opponent_power: int = 50
var opponent_max_health: int = 100
var opponent_health: int
var opponent_defense: int = 10

#moving variables
var move_distance: float = 120
var move_time: float = 1
var jump_height: float = 100
var jump_time: float = 0.5

var move_speed: float
var move_acceleration: float
var jump_speed: float
var jump_acceleration: float
var target_velocity: Vector2 = Vector2.ZERO

#animation variables
var opponent_animation: AnimationPlayer

func on_active():
	if close_range:
		#He can attack or move backwards
		var random_number = randi() %4
		if random_number == 0:
			quick()
		if random_number == 1:
			normal()
		if random_number == 2:
			power()
		if random_number == 3:
			move_backward()
		
	else:
		#He has to charge or move forward
		var random_number = randi() %2
		if random_number == 0:
			charge()
		if random_number == 1:
			move_backward()

func off_active():
	moving = false
	jumping = false
	opponent_animation.play("idle")

func _ready():
	#Setting up the action timers
	moving_timer = $MovingTimer as Timer
	moving_timer.wait_time = move_time
	
	#Setting up the stats
	attack = opponent_attack
	quick_attack = opponent_quick
	normal_attack = opponent_normal
	power_attack = opponent_power
	max_health = opponent_max_health
	current_health = opponent_health
	defense = opponent_defense
	
	#Setting up the moving variables
	move_speed = (2 * move_distance) / (move_time)
	move_acceleration = (2 * move_distance) / (move_time * move_time) #acceleration is negative but we want the module
	jump_speed = (-2 * jump_height) / (jump_time)
	jump_acceleration = (2 * jump_height) / (jump_time * jump_time)
	
	opponent_animation.play("idle")

func _physics_process(delta):
	#x axis movement
	if moving:
		target_velocity = target_velocity.move_toward(Vector2.ZERO, move_acceleration * delta)
	
	velocity.x = target_velocity.x
	
	#y axis movement
	if jumping:
		velocity.y += jump_acceleration * delta
	
	move_and_slide()

func move_forward():
	moving_timer.start()
	moving = true
	target_velocity = Vector2.LEFT * move_speed

func move_backward():
	moving_timer.start()
	moving = true
	target_velocity = Vector2.RIGHT * move_speed

func jump_forward():
	moving_timer.start()
	moving = true
	jumping = true
	target_velocity = Vector2.LEFT * move_speed
	velocity.y = jump_speed

func jump_bacwards():
	moving_timer.start()
	moving = true
	jumping = true
	target_velocity = Vector2.RIGHT * move_speed
	velocity.y = jump_speed

func charge():
	moving_timer.start()
	moving = true
	target_velocity = Vector2.LEFT * move_speed

func quick():
	opponent_animation.play("quick")
	Attack.emit(self, quick_attack)

func normal():
	opponent_animation.play("normal")
	Attack.emit(self, normal_attack)

func power():
	opponent_animation.play("power")
	Attack.emit(self, power_attack)


#SIGNALS
func _on_moving_timer_timeout():
	#must have a timer called MovingTimer
	PlayTurned.emit(self)
