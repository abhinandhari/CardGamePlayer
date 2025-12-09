class_name Player extends Node2D

var hand : Array[AbstractCard] = []
var id :int
var scaler = 50
var showCards: bool:
	set(value):
		showCards = value
		for card in hand:
			card.make_visible(value)
		
func _ready() -> void:
	print("Created Player : "+str(id))
	
func add_card(card):
	card.position=Vector2(120+scaler*hand.size(),120)
	card.make_visible(showCards)
	hand.append(card)
	print("Player "+str(id)+" : "+str(hand))
	print("Main Deck : " + str(DeckManager.deck))
	add_child(card)
	
		
func set_id(id:int)->void:
	self.id=id
	
func _to_string()->String:
		return "Player "+str(id)
