extends Node2D

@onready var drawButton = $DrawButton
@onready var endTurnButton = $EndTurnButton
@onready var gunCylinder = $GunCylinder
@onready var cylinderLoadedRevolve = gunCylinder.getCylinderLoadedRevolce()
@onready var cylinderLoading = gunCylinder.getCylinderLoading()
@onready var enemyStateChart = $Enemy/StateChart
@onready var discardPile = $Discard
@onready var playerDeck = $Deck
@onready var hand = $Hand
@onready var player = $Player
@onready var rewardScreen = $RewardScreen
@onready var opacityLayer = $OpacityLayer

@export var enemyScene:PackedScene

var enemy
var currentTurn = "player"
var totalEncounter = Encounter.list.size()

func instantiateEnemy():
	#if currentEncounter >= totalEncounter-1:
		#print("Game Over")
	if !(Encounter.encounterIndex > totalEncounter-1):
		enemy = Encounter.list[Encounter.encounterIndex].instantiate()
		enemy.position = Vector2(962, 350)
		add_child(enemy)
		

func checkEnemyIsDead():
	if enemy.character.healthPoint == 0:
		return true
	else:
		return false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	
	instantiateEnemy()
	
	opacityLayer.visible = false
	rewardScreen.visible = false
	drawButton.visible = false
	endTurnButton.visible = false
	cylinderLoadedRevolve.speed_scale = 2
	discardPile.totalCards = playerDeck.bullets.size()
	enemy.target = player
	
	playerDeck.shuffle()
	print("Total cards in discardPile = ", discardPile.totalCards)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gunCylinder.updateCylinderState(drawButton)
	
	if enemy.healthBar.value == 0:
		get_tree().paused = true
		opacityLayer.visible = true
		rewardScreen.visible = true

func _unhandled_input(event):
	if event.is_action_pressed("unload_bullet"):
		gunCylinder.unloadBullet(hand)

func _on_button_pressed():
	$StateChart.send_event("reload_finished")
	gunCylinder.shoot(player, enemy, hand, discardPile, endTurnButton, drawButton)

func _on_end_turn_button_pressed():	
	hand.discardRemainingBulletsInHand(discardPile)
	endTurnButton.visible = false
	discardPile.updateDiscardValue()

	$StateChart.send_event("playerEndturn_finished")

#Update current deck amount every time player draw card
func _on_hand_timeout():
	playerDeck.bullets.pop_front()
	playerDeck.updateBulletsAmountInDeck()

func _on_gun_cylinder_cylinder_loaded_revolve_anim_finished():
	gunCylinder.shoot(player, enemy, hand, discardPile, endTurnButton, drawButton)

func _on_gun_cylinder_all_bullets_shot():
	$StateChart.send_event("shoot_finished")
func _on_deck_finished_move_discard_to_deck():
	$StateChart.send_event("upkeep_finished")

func _on_discard_timeout(indicator):
	playerDeck.discardToDeck(indicator, discardPile)

func _on_player_upkeep_state_entered():
	currentTurn = "player"
	
	if playerDeck.deckIsEmpty():
		discardPile.timer.start()
	else:
		$StateChart.send_event("upkeep_finished")

func _on_player_draw_state_entered():
	hand.draw8Cards(playerDeck)
	$StateChart.send_event("draw_finished")

func _on_enemy_upkeep_state_entered():
	currentTurn = "enemy"
	#reduce enemy buff counter
	#remove enemy buff if counter reaches 0
	for buff in enemy.buffs:
		var index = enemy.buffs.find(buff)
		buff.period -= 1
		#buff.period -= 1
		if buff.period == 0:
			enemy.removeStatus(index)
		
	$StateChart.send_event("enemyUpkeep_finished")

func _on_enemy_exec_intention_state_entered():
	enemy.executeIntention()
	$StateChart.send_event("enemyExecIntention_finished")

func _on_enemy_action_finished():
	$StateChart.send_event("enemyExecIntention_finished")

func _on_enemy_end_turn_state_entered():
	$StateChart.send_event("enemyEndTurn_finished")

func _on_reward_screen_continue_pressed():	
	enemy.queue_free()
	
	Encounter.encounterIndex += 1
	instantiateEnemy()
	
	SceneTransition.change_scene(get_tree())
	#get_tree().reload_current_scene()
