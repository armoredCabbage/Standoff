extends Node2D

@onready var button = $Button
@export var bullet:Bullet
var handIndex:int
var isLoaded:bool = false

signal buttonPressed()

func _ready():
	button.disabled = false

func _on_button_pressed():
	buttonPressed.emit()

func _on_button_mouse_entered():
	$BulletHighlighted.visible = true

func _on_button_mouse_exited():
	$BulletHighlighted.visible = false

func disableBullet():
	button.disabled = true

func enableBullet():
	button.disabled = false
