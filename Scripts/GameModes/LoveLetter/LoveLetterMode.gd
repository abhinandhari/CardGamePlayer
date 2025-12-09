class_name LoveLetterMode extends AbstractGameMode

func _init() -> void:
	gameModeName="LoveLetter"
	minPlayerCount=2
	maxPlayerCount=8
	startingCardCount=1
	
func create_deck(rules="DEFAULT"):
	var deck :Array[AbstractCard]=[]
	for i in range(5): #Guards
		pass
		deck.append(load_up_scene().initialize(1)) 
	for i in range(2):
		deck.append(load_up_scene().initialize(2)) 
		deck.append(load_up_scene().initialize(3)) 
		deck.append(load_up_scene().initialize(4)) 
		deck.append(load_up_scene().initialize(5)) 
		pass
	deck.append(load_up_scene().initialize(6)) 
	deck.append(load_up_scene().initialize(7)) 
	deck.append(load_up_scene().initialize(8)) 
	return deck

func card_game_start():
	PlayerManager.deal_to_all_players(3)
	pass
