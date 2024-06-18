extends Node2D

#var gunCylinder: Array[Node2D] = []
#var revolveAnimationCounter = 0
#var cylinderIndex = 0

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

func drawCards():
	for n in 8:
			#Assign bullets from deck to each bulletButtons
		hand.bulletsInHand[n].bullet = playerDeck.bullets[n]
			#Assign handIndex to each bullet in hand
		hand.bulletsInHand[n].handIndex = n
			#Change bullet status to "isNotLoaded"
		hand.bulletsInHand[n].isLoaded = false
		
		print("Draw %s to hand index %d" % [hand.bulletsInHand[n].bullet.name, hand.bulletsInHand[n].handIndex])
	initiateHand()

func deckIsEmpty():
	#Check if deck is empty
	if playerDeck.bullets.size() == 0:
		return true
	return false

func initiateHand():
	hand.showHands()
	hand.enableAllBullets()

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
				if deckIsEmpty():
					discardPile.timer.start()
				elif playerDeck.bullets.size() == playerDeck.totalCardsInDeck:
					changeState()
				else:
					changeState()
		turnPhase.playerDraw:
			if phaseHasChange:
				print("Player Draw ", currentPhase)
				drawCards()
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


#func unloadBullet():
	#if gunCylinder.size() == 0:
		#print("Cylinder's Empty!")
	#else:
		#var lastIndex = gunCylinder.size() -1
		#var indexInHand = gunCylinder[lastIndex].handIndex
		#
		#hand.bulletsInHand[indexInHand].visible = true
		#gunCylinder.pop_at(lastIndex)
#
#
#func loadBullet(bullet):
	#if gunCylinder.size() < 6:
		#bullet.isLoaded = true
		#gunCylinder.append(bullet)
		#bullet.visible = false
	#else:
		#print("Cylinder's Full!!")


#func updateCylinderState():
	#if gunCylinder.size() < 6:
		#cylinderLoading.visible = true
		#cylinderLoadedRevolve.visible = false
		#
		#drawButton.visible = false
		#
		#cylinderLoading.frame = gunCylinder.size()
	#elif gunCylinder.size() == 6:
		#cylinderLoading.visible = false
		#cylinderLoadedRevolve.visible = true
		#
		#drawButton.visible = true


#func resetCylinderState():
	#gunCylinder.clear()
	#cylinderLoading.visible = true
	#cylinderLoadedRevolve.visible = false
	#
	#drawButton.visible = false


func _on_button_pressed():
	changeState()
	gunCylinder.shoot(enemy, hand, discardPile, endTurnButton, drawButton)


#func applyBulletEffect():
	#var currentBullet = gunCylinder.[cylinderIndex].bullet
	#
	#match currentBullet.type:
		#'attack':
			#enemy.calculateDamage(currentBullet.power)


#func shoot():
	#if revolveAnimationCounter == 6:
		#cylinderLoadedRevolve.stop()
		#revolveAnimationCounter = 0
		#cylinderIndex = 0
		#
		#endTurnButton.visible = true
		#resetCylinderState()
		#print("Bullets in hand is %d" % hand.bulletsInHand.size())
		#changeState()
		#
	#elif gunCylinder.size() == 6 and revolveAnimationCounter != 6:
		#var currentBullet = gunCylinder[cylinderIndex].bullet
		#var indexInHand = gunCylinder[cylinderIndex].handIndex
		#
		#print("Shooting %s in Cylinder index %d" % [currentBullet.name, cylinderIndex])
		#print("Dealt %d damage" % currentBullet.power)
		#print("\n")
		#
		#applyBulletEffect()
		#
		#cylinderLoadedRevolve.play("Revolve")
		#cylinderIndex+=1
		#revolveAnimationCounter+=1
		#
		#discardPile.appendDiscardPile(discardPile.bullets, currentBullet)
		##hand.bulletsInHand.pop_at(indexInHand)


func bulletToDiscardPile(bullet, indexInHand):
	hand.bulletsInHand[indexInHand].visible = false
	
	discardPile.appendDiscardPile(discardPile.bullets, bullet)


func discardRemainingBulletsInHand():
	for bulletNode in hand.bulletsInHand:
		if !bulletNode.isLoaded:
			print("Bullet in hand index %s moved to discard pile" % bulletNode.handIndex)
			bulletToDiscardPile(bulletNode.bullet, bulletNode.handIndex)


#func _on_cylinder_loaded_revolve_animation_finished():
	#shoot()


func _on_end_turn_button_pressed():	
	discardRemainingBulletsInHand()
	endTurnButton.visible = false
	discardPile.updateDiscardValue()

	changeState()


func _on_hand_button_1_pressed(bullet1):
	gunCylinder.loadBullet(bullet1)


func _on_hand_button_2_pressed(bullet2):
	gunCylinder.loadBullet(bullet2)


func _on_hand_button_3_pressed(bullet3):
	gunCylinder.loadBullet(bullet3)


func _on_hand_button_4_pressed(bullet4):
	gunCylinder.loadBullet(bullet4)


func _on_hand_button_5_pressed(bullet5):
	gunCylinder.loadBullet(bullet5)


func _on_hand_button_6_pressed(bullet6):
	gunCylinder.loadBullet(bullet6)


func _on_hand_button_7_pressed(bullet7):
	gunCylinder.loadBullet(bullet7)


func _on_hand_button_8_pressed(bullet8):
	gunCylinder.loadBullet(bullet8)


#Update current deck amount every time player draw card
func _on_hand_timeout():
	playerDeck.bullets.pop_front()
	playerDeck.updateBulletsAmountInDeck()


func _on_discard_timeout(indicator):
	#if "indicator" is 0, that means no more cards to move from discard pile to deck
	print("Indicator = ", indicator)
	if indicator != 0:
		playerDeck.bullets.append(discardPile.bullets[0])
		discardPile.bullets.pop_front()
		
		discardPile.updateDiscardValue()
		playerDeck.updateBulletsAmountInDeck()
		print("(From Discard) Bullets in deck = ", playerDeck.bullets.size())
	else:
		print("Indicator = ", indicator)
		playerDeck.shuffle()
		changeState()

func _on_upkeep_pressed():
	changeState()

func _on_gun_cylinder_cylinder_loaded_revolve_anim_finished():
	gunCylinder.shoot(enemy, hand, discardPile, endTurnButton, drawButton)


func _on_gun_cylinder_all_bullets_shot():
	changeState()
