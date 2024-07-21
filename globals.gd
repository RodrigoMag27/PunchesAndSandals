extends Node

signal player_stats_change(health)
signal enemy_stats_change(health)

var player_health: int:
	set(value):
		player_stats_change.emit(value)
		player_health = value

var enemy_health: int:
	set(value):
		enemy_stats_change.emit(value)
		enemy_health = value
