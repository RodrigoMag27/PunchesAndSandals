extends CharacterBody2D
class_name Entity

signal PlayTurned(entity: Entity)
signal Attack(entity: Entity, damage: int)

var attack: int
var quick_attack: int
var normal_attack: int
var power_attack: int

var max_health: int
var current_health: int

var defense: int

var active: bool:
	set(value):
		if active == value:
			return
		else:
			if value == true:
				on_active()
			if value == false:
				off_active()
			active = value

func on_active() -> void:
	pass

func off_active() -> void:
	pass

func damage(attack_damage: float):
	current_health -= attack_damage
