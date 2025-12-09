class_name DeckManager extends Node2D

const CARD_SCENE_PATH = "res://Scenes/card.tscn"
const CARD_SCRIPT_PATH = "res://Scripts/GameModes/***/CardLogic/***Card.gd"
static var gameModeName:String
static var deck:Array[AbstractCard]

func _ready() -> void:
	print("Player Manager has been created")
	gameModeName="DEV"
#TO DO FIX THE UNNECESSARY GAMEMODENAME, WE NEED ABSTRACT STUFF
	
static func createCardsForGameMode(type:AbstractGameMode):
	deck = type.create_deck()
	return deck
	
static func draw_card(source:Array[AbstractCard] = deck) -> AbstractCard:
	var cardDrawn = source.pop_back()
	cardDrawn.get_parent().remove_child(cardDrawn)
	return cardDrawn
		
#I do not think this is the best way to do this.	
static func empty_deck_actions(node :Node2D)->void: 
		match node.name:
			"GameArea":
				print("Deck is now empty")
				var controlNode :Control= node.get_node_or_null("Controls/DrawCard")
				print(controlNode)
				controlNode.disabled=true
				controlNode.text="EMPTY DECK!"
				pass
				
