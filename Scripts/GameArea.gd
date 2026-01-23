class_name GameArea extends Node2D

var tween
var deck:Array[AbstractCard]
@onready var centerOfScreen: Vector2=get_viewport().get_visible_rect().size / 2
static var gameMode:AbstractGameMode
@export var playerCount:int 
@export var duration:float
static var staticCenterOfScreen
var cardGameSize = Vector2(-150,-200)

func _ready() -> void:
	add_child(gameMode)
	var importantUIElements = gameMode.render_ui_elements()
	for ele in importantUIElements:
		$ModeSpecificElements.add_child(ele)
	$Controls/DrawCard.visible=gameMode.drawButtonNeeded
	staticCenterOfScreen=centerOfScreen-gameMode.cardSizeOffset
	tween=create_tween()
	print("Game Mode "+ gameMode.gameModeName+" launching with "+str(playerCount)+" players.")
	PlayerManager.create_players(self,playerCount)
	create_deck(gameMode)
	gameMode.setup_discard_pile($Controls/DiscardPile)
	await tween.finished
	$Controls.visible=true
	gameMode.turn_started.connect(_on_turn_start)
	gameMode.turn_ended.connect(_on_turn_end)
	gameMode.card_game_start() #needs refinement.
	
func create_deck(gameMode:AbstractGameMode)->void:
	deck = DeckManager.createCardsForGameMode(gameMode)
	deck.shuffle()
	for card in deck:
		$Deck.add_child(card)
		startupDeckAnimation(card)
	
#	Preferably, this gets handled elsewhere . for now keeping it here
func startupDeckAnimation(child):
	tween.parallel().tween_property(child,"position",staticCenterOfScreen,duration).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(child, "scale", Vector2(0.15, 0.2), duration).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(child, "rotation_degrees", 0, duration).set_trans(Tween.TRANS_CIRC)
	pass
	
func _on_draw_card_pressed() -> void:
	print("Parent scene")
	print("Drawing card...")
	#Deck not hiding said card
	PlayerManager.deal_to_player()
	if(DeckManager.deck.is_empty()):
		hide_draw_card_button()
	#Commenting temporarily. 
	#TODO: Player should only be updated when the turn is completedly resolved

static func get_game_mode():
	return gameMode

func hide_draw_card_button(isEmpty: bool=true):
	if(isEmpty):
		get_node("Controls/DrawCard").text="EMPTY DECK !"
	get_node("Controls/DrawCard").disabled=isEmpty

func _on_turn_start():
	if(gameMode.drawButtonNeeded):
		hide_draw_card_button(DeckManager.isDeckEmpty)
		
func _on_turn_end():
	if(gameMode.drawButtonNeeded):
		hide_draw_card_button(DeckManager.isDeckEmpty)
