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
	RESOLVING,
	ROUND_COMPLETE
}

func _init() -> void:
	gameModeName="LoveLetter"
	minPlayerCount=2
	maxPlayerCount=8
	startingCardCount=1
	cardSizeOffset=Vector2(25,50)
	currentGameState=GameState.IDLE
	drawButtonNeeded=true
	requiresPlayerNames=true
	
var selectedPlayer #VARIABLE WHICH SHOULD BE STORING SELECTED PLAYER.

var uiElements =[]

signal sage_card(card)
signal baron_card(losingPlayer)

func create_deck(rules="DEFAULT"):
	var deck :Array[AbstractCard]=[]
	var card
	for i in range(5):
		card=load_up_card_scene().initialize(1) #Guards
		deck.append(card) 
		pass
	for i in range(5):
		deck.append(load_up_card_scene().initialize(2)) 
		deck.append(load_up_card_scene().initialize(3)) 
		deck.append(load_up_card_scene().initialize(4)) 
		deck.append(load_up_card_scene().initialize(5)) 
		pass
	deck.append(load_up_card_scene().initialize(6)) 
	deck.append(load_up_card_scene().initialize(7)) 
	deck.append(load_up_card_scene().initialize(8))
	pass 
	connect_card_signals(deck)
	connect_player_signals(PlayerManager.players)
	return deck
		
func card_game_start():
	PlayerManager.deal_to_all_players(1)
	PlayerManager.start_turn()
	for player in PlayerManager.players:
		player.player_selected.connect(_on_player_selected)
	print(PlayerManager.players)
	emit_signal("perform_transition","Turn of : " + PlayerManager.currentPlayer.displayPlayer(),true)
	pass


func _on_playing_card(cardPlayed,player):
	print("Requesting playing card ->"+str(cardPlayed))
	cardInPlay=cardPlayed
	if(cardPlayed.cardType==CardType.HANDMAID):
		resolve_maid_play(player)
		return
	currentGameState=GameState.WAITING_FOR_TARGET
	highlight_valid_players(cardPlayed.cardType)
					
func highlight_valid_players(cardType):
	print("Highlighting valid players")
	var collection = PlayerManager.players.duplicate()
	for player in collection:
		if(player.protected):
			collection.erase(player)
	if(collection.size()==1):
		emit_signal("perform_transition","Unable to choose anyone...",false)
		end_of_turn()
	else:
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

	#ui_element.get_node("GuardGuess").visible=true
	
	#ui_element.get_node("SageSelect").visible=true
	#emit_signal("sage_card",destinationPlayer)
	
	#ui_element.get_node("BaronFight").visible=true
	#emit_signal("baron_card",sourcePlayer,destinationPlayer)
	resolve_prince_play(selectedPlayer)
	match cardInPlay.cardType:
		CardType.GUARD:
			#ui_element.get_node("GuardGuess").visible=true
			print(cardInPlay.displayText + " is played")
		CardType.SAGE:
			#ui_element.get_node("SageGuess").visible=true
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
	uiElements.append(load("res://Scenes/LoveLetter/HelperScenes/guard_guess.tscn").instantiate())
	uiElements.get(CardType.GUARD).guard_guess_selected.connect(resolve_guard_play)
	uiElements.append(load("res://Scenes/LoveLetter/HelperScenes/sage_select.tscn").instantiate())
	uiElements.get(CardType.SAGE).sage_selected.connect(resolve_sage_play)
	uiElements.append(load("res://Scenes/LoveLetter/HelperScenes/baron_fight.tscn").instantiate())
	uiElements.get(CardType.BARON).baron_selected.connect(resolve_baron_play)
	return uiElements
	
func end_of_turn():
	await get_tree().create_timer(2).timeout
	emit_signal("turn_ended",cardInPlay,PlayerManager.currentPlayer)
	emit_signal("perform_transition","Turn ends...",false)
	reset_for_new_turn()
	#Simply emulating next turn. Multiplayer will use another logic
	load_next_player()

func reset_for_new_turn():
	cardInPlay=null
	selectedPlayer=null
	currentGameState=GameState.IDLE
	
func load_next_player():
	if(PlayerManager.players.size()==1):
		print("GAME COMPLETED")
		currentGameState=GameState.ROUND_COMPLETE
		emit_signal("game_ended",PlayerManager.currentPlayer)
	else:
	#await get_tree().create_timer(1.0).timeout
		currentGameState=GameState.IDLE
		PlayerManager.update_current_player()
		emit_signal("perform_transition","Turn of : " + PlayerManager.currentPlayer.displayPlayer(),true)
		emit_signal("turn_started")
	
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
	
func resolve_sage_play():
	currentGameState=GameState.RESOLVING
	end_of_turn()
	
func resolve_baron_play(losingPlayer):
	currentGameState=GameState.RESOLVING
	if(losingPlayer==null):
		emit_signal("perform_transition","No one lost...",false)
	else:
		emit_signal("perform_transition",losingPlayer.displayPlayer()+"lost...",false)
		PlayerManager.remove_player(losingPlayer)
	end_of_turn()
	
func resolve_maid_play(player):
	player.protected=true
	emit_signal("perform_transition",PlayerManager.currentPlayer.displayPlayer()+" is now protected...",false)
	print("RESOLVED")
	end_of_turn()
	
func resolve_prince_play(player:Player):
	player.discard_card(player.hand.get(0))
	PlayerManager.deal_to_player(player)
	end_of_turn()
	pass
