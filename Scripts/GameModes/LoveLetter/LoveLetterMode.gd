class_name LoveLetterMode extends AbstractGameMode

enum CardType {
	GUARD,
	SAGE,
	BARON,
	HANDMAID,
	PRINCE,
	KING,
	QUEEN,
	PRINCESS
}
enum GameState{
	IDLE,
	WAITING_FOR_TARGET,
	RESOLVING
}
func _init() -> void:
	gameModeName="LoveLetter"
	minPlayerCount=2
	maxPlayerCount=8
	startingCardCount=1
	cardSizeOffset=Vector2(25,50)
	currentState=GameState.IDLE
	
func create_deck(rules="DEFAULT"):
	var deck :Array[AbstractCard]=[]
	var card
	for i in range(5):
		card=load_up_scene().initialize(1) #Guards
		deck.append(card) 
		pass
	for i in range(2):
		deck.append(load_up_scene().initialize(2)) 
		deck.append(load_up_scene().initialize(3)) 
		deck.append(load_up_scene().initialize(4)) 
		deck.append(load_up_scene().initialize(5)) 
		pass
	deck.append(load_up_scene().initialize(6)) 
	deck.append(load_up_scene().initialize(7)) 
	deck.append(load_up_scene().initialize(8)) 
	connect_card_signals(deck)
	return deck
	
func connect_card_signals(deck):
	for card in deck:
		card.connect("playing_card", _on_playing_card)


	
func card_game_start():
	PlayerManager.deal_to_all_players(1)
	PlayerManager.start_turn()
	#Hopefully temporary architecture flop
	for player in PlayerManager.players.values():
		player.connect("player_selected", Callable(self, "_on_player_selected"))
	pass
	
func _on_playing_card(cardPlayed,player):
	print("Requesting playing card ->"+str(cardPlayed))
	currentState=GameState.WAITING_FOR_TARGET
	highlight_valid_players(cardPlayed.cardType)
	cardInPlay=cardPlayed
					
func highlight_valid_players(cardType):
	print("Highlighting valid players")
	#Write your selection validation logic here
	var collection = PlayerManager.players
	PlayerManager.enable_selection(collection)
	#Possibly a highlight function. UI change preferred
	pass
	
func _on_player_selected(selectedPlayer):
	print("Selection works!")
	print(selectedPlayer)
	if(currentState!=GameState.IDLE):
		perform_action_to_player(selectedPlayer)
		print("Something happens here")
	else:
		print("Nothing should happen")
		
func perform_action_to_player(destinationPlayer,sourcePlayer=PlayerManager.currentPlayer):
	match cardInPlay.cardType:
		CardType.GUARD:
			print(cardInPlay.displayText + " is played")
		CardType.SAGE:
			print(cardInPlay.displayText + " is played")
		CardType.BARON:
			print(cardInPlay.displayText + " is played")
		CardType.HANDMAID:
			print(cardInPlay.displayText + " is played")
		CardType.PRINCE:
			print(cardInPlay.displayText + " is played")
		CardType.KING:
			print(cardInPlay.displayText + " is played")
		CardType.QUEEN:
			print(cardInPlay.displayText + " is played")
		CardType.PRINCESS:
			print(cardInPlay.displayText + " is played")
		_:
			print("Invalid move...")
	pass
	
