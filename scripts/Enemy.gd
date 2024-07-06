extends Node2D

@export var enemy:Character
@export var intention:Dictionary
@onready var enemyNameLabel = $EnemyName
@onready var enemyHPLabel = $EnemyHP

@onready var currentEnemyHP = enemy.healthPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	enemyNameLabel.text = enemy.name
	enemyHPLabel.text = "%d / %d" % [currentEnemyHP, enemy.healthPoint]

func calculateDamage(damageDealt):
	currentEnemyHP -= damageDealt
	updateCurrentHP(clamp(currentEnemyHP, 0, enemy.healthPoint))

func updateCurrentHP(value):
	enemyHPLabel.text = "%d / %d" % [value, enemy.healthPoint]
