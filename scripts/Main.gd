extends Node2D

@onready var drawButton = $DrawButton
@onready var endTurnButton = $EndTurnButton
@onready var gunCylinder = $GunCylinder
@onready var cylinderLoadedRevolve = gunCylinder.getCylinderLoadedRevolce()
@onready var cylinderLoading = gunCylinder.getCylinderLoading()
@onready var enemy = $Enemy
@onready var discardPile = $Discard
@onready var playerDeck = $Deck
@onready var hand = $Hand

enum turnPhase {playerUpkeep, playerDraw, playerReload, playerShoot, playerEndTurn, enemyUpkeep, enemyExecIntentions, enemyTurnEnd}
enum gameState {menu, started, paused, gameOver}

var currentPhase
var phaseHasChange = true

# Called when the node enters the scene tree for the first time.
func _ready():
	drawButton.visible = false
	endTurnButton.visible = false
	cylinderLoadedRevolve.speed_scale = 2
	discardPile.totalCards = playerDeck.bullets.size()
	
	playerDeck.shuffle()
	print("Total cards in discardPile = ", discardPile.totalCards)
	
	currentPhase = turnPhase.playerUpkeep

func changeState():
	if currentPhase == 4:
		currentPhase = 0
	else:
		currentPhase+=1
	
	print("Phase changing ... ", currentPhase)
	phaseHasChange = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gunCylinder.updateCylinderState(drawButton)
	
	match currentPhase:
		turnPhase.playerUpkeep:
			if phaseHasChange:
				print("Player Upkeep ", currentPhase)
				print("Bullets in deck = ", playerDeck.bullets.size())
				phaseHasChange = false
				if playerDeck.deckIsEmpty():
					discardPile.timer.start()
				elif playerDeck.bullets.size() == playerDeck.totalCardsInDeck:
					changeState()
				else:
					changeState()
		turnPhase.playerDraw:
			if phaseHasChange:
				print("Player Draw ", currentPhase)
				hand.draw8Cards(playerDeck)
				phaseHasChange = false
				changeState()
		turnPhase.playerReload:
			if phaseHasChange:
				print("Player Reload ", currentPhase)
				phaseHasChange = false
		turnPhase.playerShoot:
			if phaseHasChange:
				print("Player Shoot ", currentPhase)
				phaseHasChange = false
		turnPhase.playerEndTurn:
			if phaseHasChange:
				hand.disableAllBullets()
				print("Player End Turn ", currentPhase)
				phaseHasChange = false
				#changeState()

func _unhandled_input(event):
	if event.is_action_pressed("unload_bullet"):
		gunCylinder.unloadBullet(hand)

func _on_button_pressed():
	changeState()
	gunCylinder.shoot(enemy, hand, discardPile, endTurnButton, drawButton)

func _on_end_turn_button_pressed():	
	hand.discardRemainingBulletsInHand(discardPile)
	endTurnButton.visible = false
	discardPile.updateDiscardValue()

	changeState()

#Update current deck amount every time player draw card
func _on_hand_timeout():
	playerDeck.bullets.pop_front()
	playerDeck.updateBulletsAmountInDeck()

func _on_upkeep_pressed():
	changeState()

func _on_gun_cylinder_cylinder_loaded_revolve_anim_finished():
	gunCylinder.shoot(enemy, hand, discardPile, endTurnButton, drawButton)

func _on_gun_cylinder_all_bullets_shot():
	changeState()

func _on_deck_finished_move_discard_to_deck():
	changeState()

func _on_discard_timeout(indicator):
	playerDeck.discardToDeck(indicator, discardPile)
