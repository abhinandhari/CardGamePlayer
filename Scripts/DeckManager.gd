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
##		The cards should be contained within the game mode itself
	#match type.gameModeName:
		#"LOVE_LETTER":  #BasicLoveLetter Game

		#"DEV":
			#print("Devmode, creating smol deck")
			#for i in range(1,9):
				#deck.append(createCard(i,type.gameModeName))
	#return deck
	
static func draw_card() -> AbstractCard:
	#if deck.size() > 0:
		return deck.pop_back()	
	#return createCard(-1,"Invalid")
	
#Actions to be performed whenever deck is empty.
#I do not think this is the best way to do this.	
static func empty_deck_actions(node :Node2D)->void: 
		match node.name:
			"GameArea":
				print("Reached this snippet")
				var controlNode :Control= node.get_node_or_null("Controls/DrawCard")
				print(controlNode)
				controlNode.disabled=true
				controlNode.text="EMPTY DECK!"
				pass
				
static func distributeToPlayers(players:Player,gameMode:AbstractGameMode,noOfCards):
	for i in noOfCards:
		pass
	pass
