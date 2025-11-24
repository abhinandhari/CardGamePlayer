class_name GameArea extends Node2D

var tween
var deck:Array[AbstractCard]
@onready var centerOfScreen: Vector2=get_viewport().get_visible_rect().size / 2
var gameMode:AbstractGameMode
@export var playerCount:int 
@export var duration:float
	
func _ready() -> void:
	tween=create_tween()
	print("Game Mode "+ gameMode.gameModeName+" launching with "+str(playerCount)+" players.")
	create_players(playerCount)
	create_deck(gameMode)
	tween.parallel().tween_property($Controls,"visible",true,duration+0.25) #Enable Controls
	#DeckManager.distributeToPlayers(players,gameMode,gameMode.startingCardCount)
	
func create_deck(gameMode:AbstractGameMode)->void:
	deck = DeckManager.createCardsForGameMode(gameMode)
	deck.shuffle()
	for card in deck:
		$Deck.add_child(card)
		animateCard(card)

func create_players(count:int)->void:	
	for i in range(count):
		var newPlayer = Player.new()
		newPlayer.set_id(i+1)
		PlayerManager.add_player(newPlayer)
		add_child(newPlayer)
	pass
		
func animateCard(child):
	tween.parallel().tween_property(child,"position",centerOfScreen,duration).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(child, "scale", Vector2(0.15, 0.2), duration).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(child, "rotation_degrees", 0, duration).set_trans(Tween.TRANS_CIRC)
	pass
	
func _on_draw_card_pressed() -> void:
	print("Drawing card...")
	var cardDrawn = DeckManager.draw_card()
	if(cardDrawn.get_power()==-1):
		return
	print("Card Drawn is : "+cardDrawn.get_title())
	$Deck.remove_child(cardDrawn)
	if(deck.is_empty()):
		DeckManager.empty_deck_actions(self)
	pass
