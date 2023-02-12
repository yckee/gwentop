extends Node2D

onready var CardDB = preload("res://Data/CardDB.gd")
export(String) var card_name
export var card_size = Vector2(250, 350)


var card_scale setget change_card_scale
var dealt = false

func _ready():
	var face_text = CardDB.CARDS[card_name].face_path
	$Face.texture = load(face_text)
	self.card_scale = Vector2(0.5, 0.5)

func change_card_scale(card_scale):
	scale = card_scale
	$Border.scale = card_size / $Border.texture.get_size()
	$Face.scale = card_size / $Face.texture.get_size()

func move_card(dest, rotate = null, _scale = null):
	var tween := create_tween()
#	print("card rect_rotation %s" % self.rect_rotation)
	tween.tween_property(self, "position", dest, 0.7).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if rotate != null:
		tween.parallel().tween_property(self, "rotation", rotate, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	
#	$Tween.interpolate_property(self, "global_position", rect_position, dest, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
#	if rotate != null:
#		$Tween.interpolate_property(self, "rect_rotation", rect_rotation, rotate, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
#	if rotate != null:
#		$Tween.interpolate_property(self, "rect_scale", rect_scale, _scale, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)	
#	$Tween.start()


func _on_Card_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
