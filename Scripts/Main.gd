extends Node

onready var CardManager = $CardManager

func _ready():
	CardManager.draw_cards(3)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		CardManager.draw_cards(1)
