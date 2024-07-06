extends Node2D

@export var character:Character
@export var sprite:Texture
@onready var enemyNameLabel = $EnemyNameLabel
@onready var healthBar = $EnemyHealthBar
@onready var stateChart = $StateChart

var buffs:Array[Node2D]
var intentionToExecute

signal action_finished

var target:Node2D
var hasAttacked = false

var attack_intention_preload = preload("res://data/intentions/desperado_attack_intention.tscn")
var dodge_intention_preload = preload("res://data/intentions/desperado_dodge_intention.tscn")
@onready var attack_intention
@onready var dodge_intention

var intentions = [attack_intention, dodge_intention]

func _ready():
	enemyNameLabel.text = character.name
	healthBar.value = character.healthPoint
	attack_intention = instantiateIntentionUI(attack_intention_preload)
	dodge_intention = instantiateIntentionUI(dodge_intention_preload)
	
	attack_intention.attack_finished.connect(_on_attack_finished)
	#intention.intentionUIScene.intentionUI.value.text = "%d X 6" % enemyAttribute.intentions[0].value

func _on_attack_finished():
	$StateChart.send_event("toAttack")

func clearBuffs():
	character.buffs.clear()

func showIntentionUI(index):
	intentions[index].showIntentionIcon()

func hideIntentionUI(index):
	intentions[index].hideIntentionIcon()

func instantiateIntentionUI(intention):
	var intentTemp = intention.instantiate()
	add_child(intentTemp)
	
	intentTemp.position = Vector2(0, -111)
	return intentTemp

func freeIntentionUI(intention):
	intention.queue_free()

func calculateDamage(damageDealt):
	healthBar.value -= damageDealt

func applyStatus(status):
	#add status for 1 turn
	status.setPeriod(1)
	buffs.append(status)
	
	var container = $StatusContainer.get_node("GridContainer")
	
	var statusIcon = TextureRect.new()
	var marginContainer = MarginContainer.new()
	var marginValue = 15
	
	marginContainer.add_theme_constant_override("margin_top", marginValue)
	marginContainer.add_theme_constant_override("margin_left", marginValue)
	marginContainer.add_theme_constant_override("margin_bottom", marginValue)
	marginContainer.add_theme_constant_override("margin_right", marginValue)
	
	container.add_child(marginContainer)
	
	statusIcon.texture = status.intention.icon
	marginContainer.add_child(statusIcon)

func removeStatus(statusIndex):
	#remove buff from array in script
	buffs.pop_at(statusIndex)
	
	#remove buff's icon from container
	var statusContainerChildren = $StatusContainer/GridContainer.get_children()
	statusContainerChildren[statusIndex].queue_free()
	

func executeIntention():
	if intentionToExecute.intention.name == "Attack":
		intentionToExecute.attack(attack_intention.intention.value, target, character.toHitChance)
		$StateChart.send_event("toDodge")
	elif intentionToExecute.intention.name == "Dodge":
		applyStatus(dodge_intention)
		$StateChart.send_event("toAttack")

func _on_desperado_attack_state_entered():
	intentionToExecute = attack_intention
	attack_intention.showIntentionIcon()

func _on_desperado_dodge_state_entered():
	dodge_intention.showIntentionIcon()
	intentionToExecute = dodge_intention

func _on_desperado_init_state_entered():
	$StateChart.send_event("toAttack")
	attack_intention.showIntentionIcon()

func _on_desperado_attack_state_exited():
	attack_intention.hideIntentionIcon()

func _on_desperado_dodge_state_exited():
	dodge_intention.hideIntentionIcon()
