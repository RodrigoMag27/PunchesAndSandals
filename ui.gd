extends CanvasLayer

@onready var health_bar: TextureProgressBar = $Control/HealthBar
@onready var stamina_bar: TextureProgressBar = $Control/StaminaBar

func _ready():
	Globals.connect("player_stats_change", change_player_ui)

func change_player_ui(health):
	health_bar.value = health
