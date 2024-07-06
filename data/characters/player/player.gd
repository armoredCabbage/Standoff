extends Node2D

@export var character:Character
@onready var currentHP = character.healthPoint
@onready var healthBar = $PlayerHealth

var buffs:Array[Effect]

func _ready():
	healthBar.value = currentHP

func calculateDamage(damageDealt):
	healthBar.value -= damageDealt
