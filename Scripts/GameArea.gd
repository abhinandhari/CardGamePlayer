class_name GameArea extends Node2D

var tween
var deck:Array[AbstractCard]
@onready var centerOfScreen: Vector2=get_viewport().get_visible_rect().size / 2
var gameMode:AbstractGameMode
@export var playerCount:int 
@export var duration:float
static var staticCenterOfScreen
var cardGameSize = Vector2(-150,-200)
func _ready() -> void:
	staticCenterOfScreen=centerOfScreen-gameMode.cardSizeOffset
	tween=create_tween()
	print("Game Mode "+ gameMode.gameModeName+" launching with "+str(playerCount)+" players.")
	PlayerManager.create_players(self,playerCount)
	create_deck(gameMode)
	await tween.finished
	$Controls.visible=true
	gameMode.card_game_start() #needs refinement.
	
func create_deck(gameMode:AbstractGameMode)->void:
	deck = DeckManager.createCardsForGameMode(gameMode)
	deck.shuffle()
	for card in deck:
		$Deck.add_child(card)
		startupDeckAnimation(card)

#func create_players(count:int)->void:	
	#for i in range(count):
		#var newPlayer = Player.new()
		#newPlayer.set_id(i+1)
		#PlayerManager.add_players(newPlayer)
		#add_child(newPlayer)
	#pass
	
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
		get_node("Controls/DrawCard").text="EMPTY DECK !"
		get_node("Controls/DrawCard").disabled=true
	PlayerManager.update_current_player()
