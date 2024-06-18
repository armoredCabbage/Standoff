extends Node2D

@export var bullets: Array[Bullet]

@onready var totalCardsInDeck = bullets.size()
@onready var cardsInDeckLabel = $CardsInDeckLabel

signal finished_move_discard_to_deck

# Called when the node enters the scene tree for the first time.
func _ready():
	updateBulletsAmountInDeck()

func updateBulletsAmountInDeck():
	cardsInDeckLabel.text = "%d" % bullets.size()

func shuffle():
	var rng = RandomNumberGenerator.new()
	for index in totalCardsInDeck:
		var randomIndex = index + rng.randi_range(0, ((totalCardsInDeck-1)-index))
		
		var temp = bullets[randomIndex]
		bullets[randomIndex] = bullets[index]
		bullets[index] = temp

func deckIsEmpty():
	#Check if deck is empty
	if bullets.size() == 0:
		return true
	return false

func discardToDeck(indicator, discardPile):
	print("Indicator = ", indicator)
	if indicator != 0:
		bullets.append(discardPile.bullets[0])
		discardPile.bullets.pop_front()
		
		discardPile.updateDiscardValue()
		updateBulletsAmountInDeck()
		print("(From Discard) Bullets in deck = ", bullets.size())
	else:
		print("Indicator = ", indicator)
		shuffle()
		emit_signal("finished_move_discard_to_deck")
