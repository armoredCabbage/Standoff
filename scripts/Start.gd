extends Node2D

var mainScene = preload("res://scenes/Main.tscn")

var main = mainScene.instantiate()

main.enemyScene = enemyScene

add_child(main)
