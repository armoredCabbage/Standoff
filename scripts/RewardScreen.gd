extends Control

@onready var continueButton = $Container/ContinueButton

signal continuePressed

func _on_continue_button_pressed():
	emit_signal("continuePressed")
