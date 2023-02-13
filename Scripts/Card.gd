extends Node2D

onready var CardDB = preload("res://Data/CardDB.gd")
export(String) var card_name
export var card_size = Vector2(250, 350)

signal play_card

var card_scale setget change_card_scale
var dealt = false
var pos_in_hand
var rotation_in_hand
var is_focused = false
var _mouse_entered = false

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
	tween.tween_property(self, "position", dest, 0.7).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if rotate != null:
		tween.parallel().tween_property(self, "rotation", rotate, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	if _scale != null:
		tween.parallel().tween_property(self, "scale", _scale, 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)

func kill_card():
	queue_free()

func make_focus():
	is_focused = true
	print (scale)
	move_card(position, 0.0, scale * 1.1)

func off_focus():
	is_focused = false
	move_card(pos_in_hand, rotation_in_hand, Vector2(0.5, 0.5))

func _unhandled_input(event):
	if event.is_action_pressed("left_click") and _mouse_entered:
		emit_signal("play_card", self)
		self.get_tree().set_input_as_handled()

func _on_Card_mouse_entered():
	_mouse_entered = true
	make_focus()

func _on_Card_mouse_exited():
	_mouse_entered = false
	off_focus()
