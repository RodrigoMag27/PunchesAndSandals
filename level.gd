extends Node2D

var current_entity: Entity

var player: Entity
var opponent: Entity

func _ready():
	player = get_tree().get_nodes_in_group("entities")[0]
	opponent = get_tree().get_nodes_in_group("entities")[1]
	
	player.connect("PlayTurned", change_current_entity)
	player.connect("Attack", attack)
	opponent.connect("PlayTurned", change_current_entity)
	opponent.connect("Attack", attack)
	
	current_entity = player
	
	current_entity.active = true

func change_current_entity(entity: Entity):
	if entity != current_entity:
		print('PLAY FROM OTHER THAN THE CURRENT ENTITY')
		return
	
	var next_entity: Entity
	
	if current_entity == player:
		next_entity = opponent
	else:
		next_entity = player
	
	current_entity.active = false
	current_entity = next_entity
	current_entity.active = true

func attack(entity: Entity, damage: int):
	if entity != current_entity:
		print('ATTACK FROM OTHER THAN THE CURRENT ENTITY')
		return
	
	var attacked_entity: Entity
	
	if current_entity == player:
		attacked_entity = opponent
	else:
		attacked_entity = player
	
	var damage_probability: float
	if damage == current_entity.quick_attack:
		damage_probability = (current_entity.attack / attacked_entity.defense) * 50 -1
	if damage == current_entity.normal_attack:
		damage_probability = (current_entity.attack / attacked_entity.defense) * 25 -1
	if damage == current_entity.power_attack:
		damage_probability = (current_entity.attack / attacked_entity.defense) * 10 -1
	
	if randi() %100 <= damage_probability:
		attacked_entity.damage(damage)
	else:
		print("Missed Hit")
	
	change_current_entity(current_entity)
