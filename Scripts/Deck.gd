extends Node2D

onready var DeckDB = preload("res://Data/DeckDB.gd")
const CardScene = preload("res://Scenes/Card.tscn")
export(String) var deck_name = "starter"

var deck_texture_size setget change_deck_texture_size

var playing_deck = []

func _ready():
	randomize()
	init_playing_deck(deck_name)
	render_deck()
	
	
func init_playing_deck(deck_name):
	var card
	for card_name in DeckDB.DECKS[deck_name]:
		card = CardScene.instance()
		card.card_name = card_name
		card.position = position
		card.connect("play_card", get_parent(), "_play_card")
		playing_deck.append(card)
	playing_deck.shuffle()
	
	
func deal_cards(num):
	var card_return = []
	for i in num:
		if playing_deck.size() <= 0: 
			render_deck()
			return card_return
			
		card_return.append(playing_deck.pop_front())

	return card_return

func render_deck():
	if playing_deck.size() == 0:
		$DeckSprite.texture = load("res://Assets/Cards/Backs/vampire empty card section.png")
	else:
		$DeckSprite.texture = load(DeckDB.DECK_BACKGROUNDS[deck_name])
	self.deck_texture_size = Vector2(100, 150)
	
	

func change_deck_texture_size(text_size):
	$DeckSprite.scale = text_size / $DeckSprite.texture.get_size()
	
