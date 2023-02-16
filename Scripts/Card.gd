extends Node2D

onready var CardDB = preload("res://Data/CardDB.gd")
export(String) var card_name
export var card_size = Vector2(250, 350)

signal card_played

var card_scale setget change_card_scale
var dealt = false
var pos_in_hand
var rotation_in_hand
var is_played = false
var _mouse_entered = false

func _ready():
	var face_text = CardDB.CARDS[card_name].face_path
	$Face.texture = load(face_text)
	self.card_scale = Vector2(0.5, 0.5)

func change_card_scale(card_scale):
	scale = card_scale
	$Border.scale = card_size / $Border.texture.get_size()
	$Face.scale = card_size / $Face.texture.get_size()

func move_card(dest, rotate = null, _scale = null, _modulate = null):
	var tween := create_tween()
	tween.tween_property(
		self, "position", dest, 0.7
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if rotate != null:
		tween.parallel().tween_property(
			self, "rotation", rotate, 0.2
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)	
	if _scale != null:
		tween.parallel().tween_property(
			self, "scale", _scale, 0.2
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	if _modulate != null:
		tween.parallel().tween_property(
			self, "modulate", _modulate, 1.0
		).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	
func play_card():
	print("playing_card")
	self.kill_card()

func kill_card():
	var tween := create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", scale * 0.3, 0.6)
	tween.parallel().tween_property(self, "modulate", Color(1,1,1,0), 0.6)
	tween.parallel().tween_property(self, "position", position + Vector2(100, -100), 0.6)
	tween.parallel().tween_property(self, "rotation", 7.0, 1.2)
	
	yield(tween, "finished")
	queue_free()

func make_focus():
	move_card(position + Vector2(0, -60), 0.0, scale * 1.2)

func off_focus():
	move_card(pos_in_hand, rotation_in_hand, Vector2(0.5, 0.5))

func _unhandled_input(event):
	if event.is_action_pressed("left_click") and _mouse_entered:
		emit_signal("card_played", self)
		is_played = true
		self.get_tree().set_input_as_handled()

func _on_Card_mouse_entered():
	_mouse_entered = true
	make_focus()

func _on_Card_mouse_exited():
	_mouse_entered = false
	if !is_played:
		off_focus()
