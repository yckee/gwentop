extends Node2D

onready var CardVars = get_node("/root/CardVariables")
onready var CardDB = preload("res://Data/CardDB.gd")
export(String) var card_name
export var card_size = Vector2(250, 350)
const BASIC_CARD_SCALE = Vector2(0.5, 0.5)
const FOCUSED_CARD_SCALE = Vector2(0.6, 0.6)

signal card_played

var CardStates = CardVariables.CardStates

var card_state = CardStates.IDLE
var card_scale setget change_card_scale
var dealt = false
var pos_in_hand
var rotation_in_hand
var is_selected = false
var _mouse_entered = false
var Arrow = Line2D.new()

func _ready():
	prepare_arrow()
	var face_text = CardDB.CARDS[card_name].face_path
	$Face.texture = load(face_text)
	self.card_scale = BASIC_CARD_SCALE

func _process(_delta):
	match card_state:
		CardStates.IDLE:
			if _mouse_entered and !CardVariables.something_is_hovered:
				make_focus()
				CardVariables.something_is_hovered = true
				card_state = CardStates.HOVERED
		CardStates.HOVERED:
			if !_mouse_entered:
				off_focus()
				CardVariables.something_is_hovered = false
				card_state = CardStates.IDLE
			if is_selected:
				card_state = CardStates.SELECTED		
		CardStates.SELECTED:
#			Arrow.visible = true
			adjuct_arrow()
		CardStates.PLAYED:
#			Arrow.visible = false
			CardVariables.something_is_hovered = false
			play_card()
			card_state = CardStates.PLACED
		CardStates.PLACED:
			pass
			

func prepare_arrow():
	Arrow.default_color = Color(1, 0.94, 0.03, 1.5)
	Arrow.width = 5
#	Arrow.visible = false
	Arrow.points = [Vector2.ZERO, Vector2.ZERO]
	add_child(Arrow)

func adjuct_arrow():
	Arrow.points[0] = position
	Arrow.points[1] = get_global_mouse_position()
	print(Arrow.points)
	

func change_card_scale(_scale):
	scale = _scale
	$Border.scale = card_size / $Border.texture.get_size()
	$Face.scale = card_size / $Face.texture.get_size()
	$CollisionShape2D.scale = card_size / 2 / $CollisionShape2D.shape.extents
	

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

func make_focus():  # TODO: fix bug with position.y being also curved
	move_card(position + Vector2(0, -60), 0.0, FOCUSED_CARD_SCALE)
	z_index = 2

func off_focus():
	move_card(pos_in_hand, rotation_in_hand, BASIC_CARD_SCALE)
	z_index = 0

func _unhandled_input(event):
	if event.is_action_pressed("left_click") and _mouse_entered:
		is_selected = true
		self.get_tree().set_input_as_handled()
	if event.is_action_released("left_click") and is_selected:
		emit_signal("card_played", self)
		self.get_tree().set_input_as_handled()
		
#		print("released")


func _on_Card_mouse_entered():
	_mouse_entered = true


func _on_Card_mouse_exited():
	_mouse_entered = false
