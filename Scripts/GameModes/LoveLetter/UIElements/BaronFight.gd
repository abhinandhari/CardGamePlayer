extends Control

signal baron_selected(losingPlayer)

func _ready():
	GameArea.get_game_mode().turn_ended.connect(_on_turn_end)
	GameArea.get_game_mode().baron_card.connect(on_card_fight)
	
func _on_turn_end(card,player):
	get_node(".").visible=false

func on_card_fight(sourcePlayer,destinationPlayer):
	print("WE REACHED HERE")
	$Label.text="Comparing between "+sourcePlayer.displayPlayer()+" & "+destinationPlayer.displayPlayer()
	var losingPlayer=null
	var sourcePlayerCard = sourcePlayer.hand.get(0)
	if(sourcePlayerCard== GameArea.get_game_mode().cardInPlay):
		sourcePlayerCard = sourcePlayer.hand.get(1)
	var destinationPlayerCard = destinationPlayer.hand.get(0)
	if(sourcePlayerCard.cardType > destinationPlayerCard.cardType):
		losingPlayer = destinationPlayer
	if(sourcePlayerCard.cardType<destinationPlayerCard.cardType):
		losingPlayer = sourcePlayer
	print("Source Player Card : "+str(sourcePlayerCard))
	print("Destination Player Card : "+str(destinationPlayerCard))
	emit_signal("baron_selected",losingPlayer)
