extends Node2D

@export var intentionUIScene:PackedScene
@export var intention:Intention
var intentionUIInstance

signal attack_finished

func _ready():
	intentionUIInstance = intentionUIScene.instantiate()
	add_child(intentionUIInstance)
	
	intentionUIInstance.visible = false
	intentionUIInstance.scale = Vector2(0.3, 0.3)
	intentionUIInstance.value.text = "%d X 6" % intention.value

func showIntentionIcon():
	intentionUIInstance.visible = true

func hideIntentionIcon():
	intentionUIInstance.visible = false

func attack(damage, target, selfToHitChance):
	for n in 6:
		var rng = RandomNumberGenerator.new()
		if snapped(rng.randf(), 0.01) <= selfToHitChance:
			target.healthBar.value -= (damage)
			print("Enemy dealt %d damage" % damage)
		else:
			print("Miss! (Enemy)")
	emit_signal("attack_finished")
