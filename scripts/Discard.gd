extends Node2D

@export var bullets: Array[Bullet]

@onready var totalCardsInDiscard = bullets.size()
@onready var cardsInDiscardLabel = $DiscardLabel
@onready var timer = $Timer

var counter = 0
var index = 0
var totalCards = 0

signal timeout(indicator)
signal drawCards

# Called when the node enters the scene tree for the first time.
func _ready():
	cardsInDiscardLabel.text = str(totalCardsInDiscard)

func appendDiscardPile(discardPile, bullet):
	discardPile.append(bullet)
	updateDiscardValue()

func updateDiscardValue():
	cardsInDiscardLabel.text = str(bullets.size())

func discardToDeck(deck):
	for bullet in bullets:
		deck.append(bullet)

func _on_timer_timeout():
	counter+=1
	
	if counter > (totalCards):
		timer.stop()
		counter = 0
		#emit_signal("drawCards")
	else:
		timer.start()
	
	emit_signal("timeout", counter)
