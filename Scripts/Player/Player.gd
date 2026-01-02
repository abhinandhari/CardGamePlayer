class_name Player extends Node2D

var hand : Array[AbstractCard] = []
var id :int
var scaler = 60
var showCards: bool:
	set(value):
		showCards = value
		for card in hand:
			card.make_visible(value)
var highlight=false

signal player_selected(player)
signal send_to_discard_pile(card,player)

func _ready() -> void:
	print("Created Player : "+str(id))
	var playerIcon :TextureButton = get_node("PlayerIcon")
	print("res://Sprites/"+GameArea.get_game_mode().gameModeName+"/PlayerSprites/player"+str(id))
	playerIcon.texture_normal=load("res://Sprites/"+GameArea.get_game_mode().gameModeName+"/PlayerSprites/player"+str(id+1)+".png")
	GameArea.get_game_mode().connect("turn_ended",_on_turn_end)
	GameArea.get_game_mode().connect("turn_started",_on_turn_start)
	queue_redraw()
		
func add_card(card):
	#card.position=Vector2(120 + scaler*hand.size(),120)
	card.make_visible(showCards)
	hand.append(card)
	card.connect("card_played", Callable(self, "_on_card_selected"))
	update_details()
	print("Player "+str(id)+" : "+str(hand))
	#print("Main Deck : " + str(DeckManager.deck))
	card.connect("playing_card",_on_playing_card)
	add_child(card)
	arrange_cards()
		
func set_id(id:int)->void:
	self.id=id
	
func _to_string()->String:
	var total_string = "Player : "+str(id)
	return total_string
	
func displayPlayer()->String:
	return "Player "+str(id+1)

func _on_player_icon_mouse_entered() -> void:
	make_details_visible()
	pass # Replace with function body.


func _on_player_icon_mouse_exited() -> void:
	get_node("UIPlayerDetails").visible=false
	highlight=false
	pass # Replace with function body.

func make_details_visible():
	update_details()
	highlight=true
	$UIPlayerDetails.visible=true
	queue_redraw()
	
	
func update_details():
	var detailBox = get_node("UIPlayerDetails/DetailBox")
	detailBox.get_node("CardCount").text=str(hand.size())

func _on_player_icon_pressed() -> void:
	print(str(id)+"PRESSED!")
	emit_signal("player_selected",self)
	#player_selected.emit(self)
	pass # Replace with function body.
	
func _draw():
	if highlight:
		draw_rect(Rect2(Vector2.ZERO, $PlayerIcon.size), Color.YELLOW, false, 25)
	if(self==PlayerManager.currentPlayer):
		draw_rect(Rect2(Vector2.ZERO, $PlayerIcon.size), Color.GREEN, false, 20)
		
func _on_turn_end(card,player):
	print("TURN END REACHED PLAYER?")
	if(self==player):
		print("Discard from player : "+str(card))
		hand.erase(card)
		emit_signal("send_to_discard_pile",card.duplicate(),self)
		card.queue_free()
	arrange_cards()
	#Disable clicks
	#$PlayerIcon.disabled=true	

func _on_turn_start(): 
	print("Turn Start send to "+str(id))
	#$PlayerIcon.disabled=false	
		
func _on_playing_card(card,player):
	print("Card is Played")
	
func discard_card(card):
	pass
	
func disable_icon(x:bool=true):
	$PlayerIcon.disabled=x

func arrange_cards():
	for i in range(hand.size()):
		hand[i].position=Vector2(120 + scaler*i,120)
	pass
