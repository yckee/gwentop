extends Node2D

onready var Deck = $Deck
var CardStates = CardVariables.CardStates

const MAX_CARDS_IN_HAND = 10
const MAX_WIDTH_OFFSET = 400.0
const MAX_HEIGHT_OFFSET = -MAX_WIDTH_OFFSET / (MAX_CARDS_IN_HAND * 7.0)
const MAX_ROTATION = (MAX_CARDS_IN_HAND * 5.0) / MAX_WIDTH_OFFSET

var hand = []
export var spread_curve: Curve
export var vert_curve: Curve
export var rotation_curve: Curve

func draw_cards(num):
	hand += Deck.deal_cards(num)
	init_cards()
	adjust_hand()

func init_cards():
	for card in hand:
		$Hand.add_child(card)

func adjust_hand():
	var width_offset =  MAX_WIDTH_OFFSET / MAX_CARDS_IN_HAND * hand.size()
	var height_offset = MAX_CARDS_IN_HAND / MAX_HEIGHT_OFFSET * hand.size()
	for i in hand.size():
		var hand_ratio = float(i) / float(hand.size() - 1) if hand.size() > 1 else 0.5
		hand[i].pos_in_hand = $Hand/HandPos.position

		hand[i].pos_in_hand.x += spread_curve.interpolate(hand_ratio) * width_offset
		hand[i].pos_in_hand.y += vert_curve.interpolate(hand_ratio) * height_offset
		hand[i].rotation_in_hand = rotation_curve.interpolate(hand_ratio) * MAX_ROTATION

		hand[i].move_card(hand[i].pos_in_hand, hand[i].rotation_in_hand)

func play_card(card):
	hand.remove(hand.find(card))
	card.card_state = CardStates.PLAYED
	adjust_hand()

#func _process(delta):
#	print(CardVariables.is_focused)
