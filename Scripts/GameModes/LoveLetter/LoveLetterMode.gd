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
	currentGameState=GameState.IDLE
	drawButtonNeeded=false
	
var selectedPlayer #VARIABLE WHICH SHOULD BE STORING SELECTED PLAYER.
var guardGuess #UI ELEMENT CREATED ON GUARD PLAY

	
func create_deck(rules="DEFAULT"):
	var deck :Array[AbstractCard]=[]
	var card
	for i in range(5):
		card=load_up_card_scene().initialize(1) #Guards
		deck.append(card) 
		pass
	for i in range(2):
		deck.append(load_up_card_scene().initialize(2)) 
		deck.append(load_up_card_scene().initialize(3)) 
		deck.append(load_up_card_scene().initialize(4)) 
		deck.append(load_up_card_scene().initialize(5)) 
		pass
	deck.append(load_up_card_scene().initialize(6)) 
	deck.append(load_up_card_scene().initialize(7)) 
	deck.append(load_up_card_scene().initialize(8)) 
	connect_card_signals(deck)
	return deck
	
func connect_card_signals(deck):
	for card in deck:
		card.connect("playing_card", _on_playing_card)


	
func card_game_start():
	PlayerManager.deal_to_all_players(1)
	PlayerManager.start_turn()
	for player in PlayerManager.players:
		player.connect("player_selected",_on_player_selected)
	print(PlayerManager.players)
	pass
	
func _on_playing_card(cardPlayed,player):
	print("Requesting playing card ->"+str(cardPlayed))
	currentGameState=GameState.WAITING_FOR_TARGET
	highlight_valid_players(cardPlayed.cardType)
	cardInPlay=cardPlayed
					
func highlight_valid_players(cardType):
	print("Highlighting valid players")
	var collection = PlayerManager.players
	PlayerManager.enable_selection(collection)
	pass
	
func _on_player_selected(selectedPlayer:Player):
	print("Selection works!")
	print(selectedPlayer)
	self.selectedPlayer=selectedPlayer
	if(currentGameState!=GameState.IDLE):
		perform_action_to_player()
	else:
		print("Nothing should happen")
	return selectedPlayer.hand.get(0)
		
func perform_action_to_player(destinationPlayer=selectedPlayer,sourcePlayer=PlayerManager.currentPlayer):
	var ui_element = get_parent().get_node(UI_COMPONENTS_NODE)
	ui_element.get_node("GuardGuess").visible=true
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
	
func render_ui_elements():
	guardGuess = load("res://Scenes/LoveLetter/HelperScenes/guard_guess.tscn").instantiate()
	guardGuess.connect("guard_guess_selected",resolve_guard_play)
	return guardGuess
	
func resolve_guard_play(selectedValue):
	currentGameState=GameState.RESOLVING
	print("The game mode got the value : "+str(selectedValue))
	print("This is compared with :"+str(selectedPlayer.hand.get(0).cardType))
	print(CardType.find_key(selectedValue))
	if(selectedValue == (selectedPlayer.hand.get(0).cardType)):
		print("Player should be out!")
		PlayerManager.remove_player(selectedPlayer)
	else:
		print("Game Continues")
	#End Turn
	end_of_turn()
	pass
	
func end_of_turn():
	guardGuess.visible=false
	selectedPlayer=null
	currentGameState=GameState.IDLE
	emit_signal("turn_ended")
	emit_signal("perform_transition","Turn ends...")
	#Simply emulating next turn. Multiplayer will use another logic
	load_next_player()

func load_next_player():
	emit_signal("turn_started")
	#await get_tree().create_timer(1.0).timeout
	currentGameState=GameState.IDLE
	PlayerManager.update_current_player()
	emit_signal("perform_transition",str(PlayerManager.currentPlayer)+" 's Turn.")

	
