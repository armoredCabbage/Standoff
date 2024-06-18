extends Node2D

var bullets: Array[Node2D] = []
var revolveAnimationCounter = 0
var cylinderIndex = 0

@onready var cylinderLoading = $Cylinder_Loading
@onready var cylinderLoadedRevolve = $Cylinder_Loaded_Revolve

signal cylinderLoadedRevolveAnimFinished
signal all_bullets_shot

func getCylinderLoading():
	return cylinderLoading

func getCylinderLoadedRevolce():
	return cylinderLoadedRevolve


func resetCylinderState(drawButton):
	bullets.clear()
	showCylinderLoadingState(drawButton)


func showCylinderLoadingState(drawButton):
	getCylinderLoading().visible = true
	getCylinderLoadedRevolce().visible = false
	
	drawButton.visible = false

func showCylinderLoadedState(drawButton):
	getCylinderLoading().visible = false
	getCylinderLoadedRevolce().visible = true
	
	drawButton.visible = true

func updateCylinderState(drawButton):
	if bullets.size() < 6:
		showCylinderLoadingState(drawButton)
		
		getCylinderLoading().frame = bullets.size()
	elif bullets.size() == 6:
		showCylinderLoadedState(drawButton)

func unloadBullet(hand):
	if bullets.size() == 0:
		print("Cylinder's Empty!")
	else:
		var lastIndex = bullets.size() -1
		var indexInHand = bullets[lastIndex].handIndex
		
		hand.bulletsInHand[indexInHand].visible = true
		bullets.pop_at(lastIndex)

func loadBullet(bullet):
	if bullets.size() < 6:
		bullet.isLoaded = true
		bullets.append(bullet)
		bullet.visible = false
	else:
		print("Cylinder's Full!!")

func applyBulletEffect(enemy):
	var currentBullet = bullets[cylinderIndex].bullet
	
	match currentBullet.type:
		'attack':
			enemy.calculateDamage(currentBullet.power)

func shoot(enemy, hand, discardPile, endTurnButton, drawButton):
	if revolveAnimationCounter == 6:
		cylinderLoadedRevolve.stop()
		revolveAnimationCounter = 0
		cylinderIndex = 0
		
		endTurnButton.visible = true
		resetCylinderState(drawButton)
		print("Bullets in hand is %d" % hand.bulletsInHand.size())
		#changeState()
		emit_signal("all_bullets_shot")
		
	elif bullets.size() == 6 and revolveAnimationCounter != 6:
		var currentBullet = bullets[cylinderIndex].bullet
		var indexInHand = bullets[cylinderIndex].handIndex
		
		print("Shooting %s in Cylinder index %d" % [currentBullet.name, cylinderIndex])
		print("Dealt %d damage" % currentBullet.power)
		print("\n")
		
		applyBulletEffect(enemy)
		
		cylinderLoadedRevolve.play("Revolve")
		cylinderIndex+=1
		revolveAnimationCounter+=1
		
		discardPile.appendDiscardPile(discardPile.bullets, currentBullet)
		#hand.bulletsInHand.pop_at(indexInHand)

func _on_cylinder_loaded_revolve_animation_finished():
	emit_signal("cylinderLoadedRevolveAnimFinished")

func _on_hand_button_1_pressed(bullet1):
	loadBullet(bullet1)

func _on_hand_button_2_pressed(bullet2):
	loadBullet(bullet2)

func _on_hand_button_3_pressed(bullet3):
	loadBullet(bullet3)

func _on_hand_button_4_pressed(bullet4):
	loadBullet(bullet4)

func _on_hand_button_5_pressed(bullet5):
	loadBullet(bullet5)

func _on_hand_button_6_pressed(bullet6):
	loadBullet(bullet6)

func _on_hand_button_7_pressed(bullet7):
	loadBullet(bullet7)

func _on_hand_button_8_pressed(bullet8):
	loadBullet(bullet8)
