class_name AbstractGameMode extends Node
#DO NOT USE DIRECTLY

@export var gameModeName:String
@export var minPlayerCount:int
@export var maxPlayerCount:int
@export var description:String
@export var startingCardCount:int
@export var drawButtonNeeded :bool= true 

var currentGameState
var cardInPlay
var transitionNode = load("res://Scenes/LoveLetter/HelperScenes/transition.tscn").instantiate()

const CARD_SCENE_PATH = "res://Scenes/card.tscn"
const CARD_SCRIPT_PATH = "res://Scripts/GameModes/***/CardLogic/***Card.gd"
const UI_COMPONENTS_NODE = "ModeSpecificElements"

static var cardSizeOffset =Vector2.ZERO

signal perform_transition(text)
signal game_ended(player)
signal turn_started
signal turn_ended(card,player)
signal card_discarded(card, player)
		
func create_deck(rules:String="DEFAULT") -> Array[AbstractCard]:
	push_error("create_deck not implemented")
	return []
	
func _to_string() -> String:
	return "MODE : "+gameModeName+\
	"\nPlayerCount : "+str(minPlayerCount)+" - "+str(maxPlayerCount)+\
	"\n"
	
func load_up_card_scene():
	var cardScene = load(CARD_SCENE_PATH).instantiate()
	var cardScript = load(CARD_SCRIPT_PATH.replace("***",gameModeName))	
	cardScene.set_script(cardScript)
	cardScene._ready()
	cardScene.set_process(true)
	cardScene.set_physics_process(true)
	return cardScene	
	
func card_game_start():
	print("IDK What should an abstract mode do?")
	pass
	
#Was using the below function until I realised I should be using signals instead.
func request_play_card(cardPlayed:AbstractCard,player):
	print("Play cannot happen,this is Abstract!!!")

func render_ui_elements():
	print("No elements created")
	return null
		
func game_completed(winnerPlayer:Player):
	emit_signal("game_ended",winnerPlayer)
	pass
	
func connect_card_signals(deck):
	for card in deck:
		card.playing_card.connect(_on_playing_card)
	
func connect_player_signals(players):
	for player in players:
		player.card_discarded.connect(_on_player_discard)
			
func _on_player_discard(card,player):
	$Controls/DiscardPile.add_to_pile(card,player)
	pass
	
func _on_playing_card(cardPlayed,player):
	print("Requesting playing card ->"+str(cardPlayed))
