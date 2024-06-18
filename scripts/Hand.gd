extends Node2D

@onready var timer = $Timer
var counter = 0
@onready var bulletsInHand: Array[Node2D] = [$Bullet1, $Bullet2, $Bullet3, $Bullet4, $Bullet5, $Bullet6, $Bullet7, $Bullet8]

signal button1_pressed(bullet1)
signal button2_pressed(bullet2)
signal button3_pressed(bullet3)
signal button4_pressed(bullet4)
signal button5_pressed(bullet5)
signal button6_pressed(bullet6)
signal button7_pressed(bullet7)
signal button8_pressed(bullet8)
signal timeout
signal initiateHand

func _ready():
	pass

func _process(delta):
	pass

func bulletToDiscardPile(bullet, indexInHand, discardPile):
	bulletsInHand[indexInHand].visible = false
	
	discardPile.appendDiscardPile(discardPile.bullets, bullet)

func discardRemainingBulletsInHand(discardPile):
	for bulletNode in bulletsInHand:
		if !bulletNode.isLoaded:
			print("Bullet in hand index %s moved to discard pile" % bulletNode.handIndex)
			bulletToDiscardPile(bulletNode.bullet, bulletNode.handIndex, discardPile)

func showHands():
	timer.start()


func disableAllBullets():
	for bullet in bulletsInHand:
		bullet.disableBullet()


func enableAllBullets():
	for bullet in bulletsInHand:
		bullet.enableBullet()


func _on_bullet_1_button_pressed():
	button1_pressed.emit($Bullet1)


func _on_bullet_2_button_pressed():
	button1_pressed.emit($Bullet2)


func _on_bullet_3_button_pressed():
	button1_pressed.emit($Bullet3)


func _on_bullet_4_button_pressed():
	button1_pressed.emit($Bullet4)


func _on_bullet_5_button_pressed():
	button1_pressed.emit($Bullet5)


func _on_bullet_6_button_pressed():
	button1_pressed.emit($Bullet6)


func _on_bullet_7_button_pressed():
	button1_pressed.emit($Bullet7)


func _on_bullet_8_button_pressed():
	button1_pressed.emit($Bullet8)


func _on_timer_timeout():
	emit_signal("timeout")
	bulletsInHand[counter].visible = true
	counter+=1
	
	if counter > 7:
		timer.stop()
		counter = 0
	else:
		timer.start()

func draw8Cards(playerDeck):
	for n in 8:
			#Assign bullets from deck to each bulletButtons
		bulletsInHand[n].bullet = playerDeck.bullets[n]
			#Assign handIndex to each bullet in hand
		bulletsInHand[n].handIndex = n
			#Change bullet status to "isNotLoaded"
		bulletsInHand[n].isLoaded = false
		
		print("Draw %s to hand index %d" % [bulletsInHand[n].bullet.name, bulletsInHand[n].handIndex])
	showHands()
	enableAllBullets()
