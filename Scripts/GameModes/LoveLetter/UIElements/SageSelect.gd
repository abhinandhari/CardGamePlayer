extends Control

signal sage_selected(value)

func _ready():
	GameArea.get_game_mode().connect("turn_ended",_on_turn_end)
	GameArea.get_game_mode().connect("sage_card",show_connected_card)
	
func _on_turn_end(card,player):
	get_node(".").visible=false
	
func _on_button_pressed() -> void:
	print("Closing the screen")
	emit_signal("sage_selected")
	pass # Replace with function body.
	
func show_connected_card(player):
	print("TTT I Reached here with player : "+str(player))
	print("The card he has is : "+str(player.hand))
	var requiredCard = player.hand.get(0)
	var nameOfCard = LoveLetterMode.CardType.find_key(requiredCard.cardType)
	$Panel/VBoxContainer/Title.text=str("CARD OF " + player.displayPlayer() +"...")
	$Panel/VBoxContainer/CardName.text=nameOfCard
	$Panel/VBoxContainer/CardImage.texture=requiredCard.get_node("ImageDetails/Art").texture
	#$Panel/VBoxContainer/CardImage.scale = Vector2(0.5,0.5)
	print(player.hand.get(0).get_node("ImageDetails/Art"))
	print_tree_pretty()
