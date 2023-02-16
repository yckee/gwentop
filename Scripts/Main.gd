extends Node

onready var CardManager = $CardManager

func _ready():
	CardManager.draw_cards(3)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_pressed("draw_card"):
		CardManager.draw_cards(1)
