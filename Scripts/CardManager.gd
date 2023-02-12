extends Node2D

onready var Deck = $Deck

const HAND_WIDTH_COEF = 155
const HAND_HEIGHT_COEF = -4.5
const HAND_ROTATION_COEF = 0.1

var hand = []
export var spread_curve: Curve
export var vert_curve: Curve
export var rotation_curve: Curve

func draw_cards(num):
	hand += Deck.deal_cards(num)
	init_cards()
	adjust_hand()

func init_cards():
	print("init cards")
	for card in hand:
		$Hand.add_child(card)

func adjust_hand():
	for i in hand.size():
		var hand_ratio = float(i) / float(hand.size() - 1) if hand.size() > 1 else 0.5
		var destination = $Hand/HandPos.position

		destination.x += spread_curve.interpolate(hand_ratio) * HAND_WIDTH_COEF
		destination.y += vert_curve.interpolate(hand_ratio) * HAND_HEIGHT_COEF
		var dest_rotation = rotation_curve.interpolate(hand_ratio) * HAND_ROTATION_COEF

		hand[i].move_card(destination, dest_rotation)

func play_card(card):
	hand.remove(hand.find(card))
