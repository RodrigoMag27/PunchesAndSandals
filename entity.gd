extends CharacterBody2D
class_name Entity

signal PlayTurned(entity: Entity)
signal Attack(entity: Entity, damage: int)

var close_range: bool = false

var attack: int
var quick_attack: int
var normal_attack: int
var power_attack: int

var max_health: int
var current_health: int:
	set(value):
		if name == "MainCharacter":
			Globals.player_health = value
		if name == "Opponent":
			Globals.enemy_health = value
		current_health = value

var defense: int

var active: bool:
	set(value):
		if active == value:
			print("SETTING THE SAME VALUE")
			print(name)
			return
		else:
			active = value
			if value == true:
				on_active()
			if value == false:
				off_active()

func on_active() -> void:
	pass

func off_active() -> void:
	pass

func damage(attack_damage: float):
	current_health -= attack_damage
	
	if current_health <= 0:
		queue_free()

