extends CanvasLayer

@onready var moveCursor = $Container/AnimationPlayer

func move_cursor():
	#self.visible = true
	moveCursor.play("move_cursor")
	await moveCursor.animation_finished
	#self.visible = false

func _ready():
	self.visible = false
