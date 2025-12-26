class_name Player extends Node2D

var hand : Array[AbstractCard] = []
var id :int
var scaler = 60
var showCards: bool:
	set(value):
		showCards = value
		for card in hand:
			card.make_visible(value)
			
signal player_selected(player)

func _ready() -> void:
	print("Created Player : "+str(id))
	var playerIcon :TextureButton = get_node("PlayerIcon")
	print("res://Sprites/"+GameArea.get_game_mode().gameModeName+"/PlayerSprites/player"+str(id))
	playerIcon.texture_normal=load("res://Sprites/"+GameArea.get_game_mode().gameModeName+"/PlayerSprites/player"+str(id)+".png")
		
func add_card(card):
	card.position=Vector2(120 + scaler*hand.size(),120)
	card.make_visible(showCards)
	hand.append(card)
	card.connect("card_played", Callable(self, "_on_card_selected"))
	update_details()
	print("Player "+str(id)+" : "+str(hand))
	print("Main Deck : " + str(DeckManager.deck))
	add_child(card)
	
		
func set_id(id:int)->void:
	self.id=id
	
func _to_string()->String:
		return "Player "+str(id)


func _on_player_icon_mouse_entered() -> void:
	make_details_visible()
	pass # Replace with function body.


func _on_player_icon_mouse_exited() -> void:
	get_node("UIPlayerDetails").visible=false
	pass # Replace with function body.

func make_details_visible():
	update_details()
	$UIPlayerDetails.visible=true
	
func update_details():
	var detailBox = get_node("UIPlayerDetails/DetailBox")
	detailBox.get_node("CardCount").text=str(hand.size())


func _on_player_icon_pressed() -> void:
	print(str(id)+"PRESSED!")
	player_selected.emit(self)
	pass # Replace with function body.
