class_name AbstractGameMode extends Node
#DO NOT USE DIRECTLY

@export var gameModeName:String
@export var minPlayerCount:int
@export var maxPlayerCount:int
@export var description:String
@export var startingCardCount:int
const CARD_SCENE_PATH = "res://Scenes/card.tscn"
const CARD_SCRIPT_PATH = "res://Scripts/GameModes/***/CardLogic/***Card.gd"
static var cardSizeOffset =Vector2.ZERO

func create_deck(rules:String="DEFAULT") -> Array[AbstractCard]:
	push_error("create_deck not implemented")
	return []
	
func _to_string() -> String:
	return "MODE : "+gameModeName+\
	"\nPlayerCount : "+str(minPlayerCount)+" - "+str(maxPlayerCount)+\
	"\n"
	
func load_up_scene():
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
	
func request_play_card(cardPlayed:AbstractCard):
	print("Play cannot happen,this is Abstract!!!")
	
	
