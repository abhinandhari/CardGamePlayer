class_name DevMode extends AbstractGameMode 

func _init() -> void:
	gameModeName="DEV"
	minPlayerCount=2
	maxPlayerCount=2
	
func create_deck(rules="DEFAULT"):
	var deck :Array[AbstractCard]=[]
	for i in range(1,9): #Guards
		deck.append(load_up_card_scene().initialize(i)) 
	return deck
