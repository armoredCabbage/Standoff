extends CanvasLayer

@onready var animPlayer = $transitionAnim
@onready var levelProgress = $LevelProgress

func change_scene(target: SceneTree) -> void:
	animPlayer.play('dissolve')
	await animPlayer.animation_finished
	
	animPlayer.play_backwards('dissolve')
	#await animPlayer.animation_finished
	
	levelProgress.visible = true
	await animPlayer.animation_finished
	levelProgress.moveCursor.play('move_cursor')
	await levelProgress.moveCursor.animation_finished
	
	animPlayer.play('dissolve')
	await animPlayer.animation_finished
	
	levelProgress.visible = false
	
	target.reload_current_scene()
	
	animPlayer.play_backwards('dissolve')
	await animPlayer.animation_finished

func play_in():
	animPlayer.play("dissolve")

func play_out():
	animPlayer.play_backwards("dissolve")
