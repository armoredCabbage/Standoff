class_name Effect
extends Resource

@export var name:String
@export var description:String
@export var type:String
@export var value:float
@export var period:int

func resetValue(target):
	target.toHitChance = 1.0
