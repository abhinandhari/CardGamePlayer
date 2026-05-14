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
	gameModeComponents={"protected":false}
	
var selectedPlayer #VARIABLE WHICH SHOULD BE STORING SELECTED PLAYER.

var uiElements =[]

signal sage_card(card)
signal baron_card(losingPlayer)

func create_deck(rules="DEFAULT"):
	var deck :Array[AbstractCard]=[]
	#var card:LoveLetterCard
	##Actual game mode
	for i in range(5):
		deck.append(load_up_card_scene().initialize(1)) 
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
	# # #Specific card testing
	#for i in range(5):
		#deck.append(load_up_card_scene().initialize(7))
		
		# One of each card
	#deck.append(load_up_card_scene().initialize(1))
	#deck.append(load_up_card_scene().initialize(2))
	#deck.append(load_up_card_scene().initialize(3))
	#deck.append(load_up_card_scene().initialize(4))
	#deck.append(load_up_card_scene().initialize(5))
	#deck.append(load_up_card_scene().initialize(6))
	#deck.append(load_up_card_scene().initialize(7))
	#deck.append(load_up_card_scene().initialize(8))

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
	emit_signal("turn_started")
	emit_signal("perform_transition","Turn of : " + PlayerManager.currentPlayer.displayPlayer(),true)
	pass


func _on_playing_card(cardPlayed,player):
	if(player!=PlayerManager.currentPlayer):
		return
	print("Requesting playing card ->"+str(cardPlayed))
	cardInPlay=cardPlayed
	if(cardPlayed.cardType==CardType.HANDMAID):
		resolve_maid_play()
		return
	if(cardPlayed.cardType==CardType.QUEEN):
		resolve_queen_play()
		return
	if(cardPlayed.cardType==CardType.PRINCESS):
		resolve_princess_play()
		return
	currentGameState=GameState.WAITING_FOR_TARGET
	highlight_valid_players(cardPlayed.cardType)
					
func highlight_valid_players(cardType):
	print("Highlighting valid players")
	var collection = PlayerManager.players.duplicate()
	var toRemove=[]
	if(cardType==CardType.GUARD || cardType==CardType.SAGE || cardType==CardType.BARON || cardType==CardType.KING):
		toRemove.append(PlayerManager.currentPlayer)
	for player in collection:
		if(player.gameComponents["protected"]):
			toRemove.append(player)
	for player in toRemove:
		collection.erase(player)
	if(collection.size()==0):
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
	return selectedPlayer.hand.get_child(0)
		
func perform_action_to_player(destinationPlayer=selectedPlayer,sourcePlayer=PlayerManager.currentPlayer):
	var ui_element = get_parent().get_node(UI_COMPONENTS_NODE)
	match cardInPlay.cardType:
		CardType.GUARD:
			ui_element.get_node("GuardGuess").visible=true
			print(cardInPlay.displayText + " is played")
		CardType.SAGE:
			ui_element.get_node("SageSelect").visible=true
			emit_signal("sage_card",destinationPlayer)
			print(cardInPlay.displayText + " is played")
		CardType.BARON:
			ui_element.get_node("BaronFight").visible=true
			emit_signal("baron_card",sourcePlayer,destinationPlayer)
			print(cardInPlay.displayText + " is played")
		CardType.HANDMAID:
			#Not needed
			print(cardInPlay.displayText + " is played")
		CardType.PRINCE:
			resolve_prince_play(selectedPlayer)
			print(cardInPlay.displayText + " is played")
		CardType.KING:
			resolve_king_play(selectedPlayer)
			print(cardInPlay.displayText + " is played")
		CardType.QUEEN:
			#Not needed
			print(cardInPlay.displayText + " is played")
		CardType.PRINCESS:
			#Not needed
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
	print("NEW PLAYER IS : ",PlayerManager.currentPlayer)
	print(PlayerManager.print_all_player_data())

func reset_for_new_turn():
	for card in PlayerManager.currentPlayer.hand.get_children():
		card.set_selectable(true)
	cardInPlay=null
	selectedPlayer=null
	currentGameState=GameState.IDLE
	
func load_next_player():
	if(PlayerManager.players.size()==1):
		print("GAME COMPLETED")
		currentGameState=GameState.ROUND_COMPLETE
		emit_signal("game_ended",PlayerManager.currentPlayer)
	elif(DeckManager.deck.is_empty()) :
		print("Game is indeed over, now checking who has the biggest card!")
		var winner = comparePlayerCards()
		print("WINNER : " + str(winner))
		emit_signal("game_ended",winner) #WInner is to be sent here
	else:
	#await get_tree().create_timer(1.0).timeout
		currentGameState=GameState.IDLE
		PlayerManager.update_current_player()
		emit_signal("perform_transition","Turn of : " + PlayerManager.currentPlayer.displayPlayer(),true)
		#Remove protection on your turn
		PlayerManager.currentPlayer.gameComponents["protected"]=false
		emit_signal("turn_started")
	
func resolve_guard_play(selectedValue):
	currentGameState=GameState.RESOLVING
	print("The game mode got the value : "+str(selectedValue))
	print("This is compared with :"+str(selectedPlayer.hand.get_child(0).cardType))
	print(CardType.find_key(selectedValue))
	if(selectedValue == (selectedPlayer.hand.get_child(0).cardType)):
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
		emit_signal("perform_transition",losingPlayer.displayPlayer()+" lost... with "+str(losingPlayer.hand.get_child(0)),false)
		PlayerManager.remove_player(losingPlayer)
	end_of_turn()
	
func resolve_maid_play():
	PlayerManager.currentPlayer.gameComponents["protected"]=true
	PlayerManager.currentPlayer.disable_icon(true)
	emit_signal("perform_transition",PlayerManager.currentPlayer.displayPlayer()+" is now protected...",false)
	print("RESOLVED")
	end_of_turn()
	
func resolve_prince_play(player:Player):
	var card :LoveLetterCard= player.hand.get_child(0)
	player.discard_card(player.hand.get_child(0))
	if(card.cardType == CardType.PRINCESS):
		emit_signal("perform_transition",player.displayPlayer()+" lost his princess...",false)
		PlayerManager.remove_player(player)
		end_of_turn()
		return
	PlayerManager.deal_to_player(player)
	end_of_turn()
	pass
	
func resolve_king_play(targetPlayer: Player):
	var sourcePlayer = PlayerManager.currentPlayer
	# 1. Find Player 1's hidden card (the one that is NOT the King currently being played)
	var sourceCard = null
	for child in sourcePlayer.hand.get_children():
		if child != cardInPlay:
			sourceCard = child
			break			
	# 2. Get Player 2's card
	var targetCard = targetPlayer.hand.get_child(0) if targetPlayer.hand.get_child_count() > 0 else null
	# Safety check: make sure both cards were found
	if sourceCard == null or targetCard == null:
		print("Swap failed: Missing cards. Source hidden card: ", sourceCard, " Target card: ", targetCard)
		end_of_turn()
		return
	# 3. Perform the swap on the node tree
	sourceCard.make_visible(false)
	sourcePlayer.hand.remove_child(sourceCard)
	targetPlayer.hand.remove_child(targetCard)
	sourcePlayer.hand.add_child(targetCard)
	targetPlayer.hand.add_child(sourceCard)
	# 4. Notify UI/Players
	emit_signal(
		"perform_transition", 
		sourcePlayer.displayPlayer() + " swapped hands with " + targetPlayer.displayPlayer(), 
		false
	)
	end_of_turn()
	pass
	
func on_turn_start(player : Player):
	#var currentPlayer=PlayerManager.currentPlayer	
	if(player!=PlayerManager.currentPlayer):
		return
	var hand_children = player.hand.get_children()
	var holds_countess = false
	var holds_restricted_card = false
	for card in hand_children:
		if card.cardType == CardType.QUEEN: # Using QUEEN from your enum as Countess placeholder
			holds_countess = true
		if card.cardType == CardType.PRINCE or card.cardType == CardType.KING or card.cardType == CardType.PRINCESS:
			holds_restricted_card = true
	for card in hand_children:
		if holds_countess and holds_restricted_card:
			if card.cardType == CardType.PRINCE or card.cardType == CardType.KING or card.cardType == CardType.PRINCESS:
				card.set_selectable(false)
			else:
				card.set_selectable(true)
		else:
			# Reset all cards to selectable under normal conditions
			card.set_selectable(true)
	pass
	
func resolve_queen_play():
	print("QUEEN REACHED")
	end_of_turn()
	pass
	
func resolve_princess_play():
	emit_signal(
	"perform_transition", 
	PlayerManager.currentPlayer.displayPlayer() + " surrendered the Princess !!! . Shame!", 
		false
	)
	PlayerManager.remove_player(PlayerManager.currentPlayer)
	end_of_turn()
	
func comparePlayerCards():
	var currWinner = []
	var highestPower = -1
	for player in PlayerManager.players:
		var playerCard :AbstractCard = player.hand.get_child(0)
		print(str(playerCard))
		if(playerCard.get_power() > highestPower):
			currWinner.clear()
			currWinner.append(player)
			highestPower = playerCard.get_power()
		elif(playerCard.get_power() == highestPower):
			currWinner.append(player)
		else:
			continue
	return currWinner
	
	
