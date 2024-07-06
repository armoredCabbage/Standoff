class_name Character
extends Resource

@export var name:String
@export var type:String
@export var healthPoint:int
@export var listIntentions:Array[Intention]
@export var toHitChance:float
@export var buffs:Array[Effect]

var currentHP = healthPoint

func calculateDamage(damage):
	healthPoint -= damage

func removeBuff():
	buffs.pop_front()

func removeAllBuffs():
	for n in buffs:
		removeBuff()
