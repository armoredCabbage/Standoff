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

# Called when the node enters the scene tree for the first time.
func _ready():
	drawButton.visible = false
	endTurnButton.visible = false
	cylinderLoadedRevolve.speed_scale = 2
	discardPile.totalCards = playerDeck.bullets.size()
	
	playerDeck.shuffle()
	print("Total cards in discardPile = ", discardPile.totalCards)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gunCylinder.updateCylinderState(drawButton)

func _unhandled_input(event):
	if event.is_action_pressed("unload_bullet"):
		gunCylinder.unloadBullet(hand)

func _on_button_pressed():
	$StateChart.send_event("reload_finished")
	gunCylinder.shoot(enemy, hand, discardPile, endTurnButton, drawButton)

func _on_end_turn_button_pressed():	
	hand.discardRemainingBulletsInHand(discardPile)
	endTurnButton.visible = false
	discardPile.updateDiscardValue()

	$StateChart.send_event("endturn_finished")

#Update current deck amount every time player draw card
func _on_hand_timeout():
	playerDeck.bullets.pop_front()
	playerDeck.updateBulletsAmountInDeck()

func _on_gun_cylinder_cylinder_loaded_revolve_anim_finished():
	gunCylinder.shoot(enemy, hand, discardPile, endTurnButton, drawButton)

func _on_gun_cylinder_all_bullets_shot():
	$StateChart.send_event("shoot_finished")

func _on_deck_finished_move_discard_to_deck():
	$StateChart.send_event("upkeep_finished")

func _on_discard_timeout(indicator):
	playerDeck.discardToDeck(indicator, discardPile)

func _on_player_upkeep_state_entered():
	if playerDeck.deckIsEmpty():
		discardPile.timer.start()
	else:
		$StateChart.send_event("upkeep_finished")

func _on_player_draw_state_entered():
	hand.draw8Cards(playerDeck)
	$StateChart.send_event("draw_finished")
