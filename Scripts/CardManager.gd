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
		hand[i].pos_in_hand = $Hand/HandPos.position

		hand[i].pos_in_hand.x += spread_curve.interpolate(hand_ratio) * HAND_WIDTH_COEF
		hand[i].pos_in_hand.y += vert_curve.interpolate(hand_ratio) * HAND_HEIGHT_COEF
		hand[i].rotation_in_hand = rotation_curve.interpolate(hand_ratio) * HAND_ROTATION_COEF

		hand[i].move_card(hand[i].pos_in_hand, hand[i].rotation_in_hand)

func _play_card(card):
	print("playinf")
	hand.remove(hand.find(card))
	card.move_card(Vector2(640, 300))
#	card.kill_card()
