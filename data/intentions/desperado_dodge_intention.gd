extends Node2D

@export var intentionUIScene:PackedScene
@export var intention:Intention
@export var period:int
var intentionUIInstance

func _ready():
	intentionUIInstance = intentionUIScene.instantiate()
	add_child(intentionUIInstance)
	
	intentionUIInstance.visible = false
	intentionUIInstance.scale = Vector2(0.3, 0.3)

func setPeriod(addedPeriod):
	period += addedPeriod

func showIntentionIcon():
	intentionUIInstance.visible = true

func hideIntentionIcon():
	intentionUIInstance.visible = false

func getDodgeEffect():
	return intention.effect
