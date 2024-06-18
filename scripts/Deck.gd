extends Node2D

@export var bullets: Array[Bullet]

@onready var totalCardsInDeck = bullets.size()
@onready var cardsInDeckLabel = $CardsInDeckLabel

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
