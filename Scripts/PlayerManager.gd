class_name PlayerManager extends Node

static var players:Array = []
static var currentPlayer: Player :
	get:
		return currentPlayer
	set(value):
		currentPlayer = value
		currentPlayer.showCards=true
		print("Current player changed:", value)
		
static var angle_step #Used to position the players
static var radius_x:float = 720
static var radius_y:float = 360
const playerScene = preload("res://Scenes/player.tscn")

signal player_clicked(player)
signal perform_transition(text)

func _ready() -> void:
	print("Player Manager Created.")
	
static func create_players(parent:Node,count : int): #Parent is to Circumvent godot scene creation
	for i in range(0,count):
		var newPlayer = playerScene.instantiate()
		newPlayer.id=i
		if(currentPlayer==null):
			currentPlayer=newPlayer
		parent.get_node("Players").add_child(newPlayer)
		players.append(newPlayer)
	#position the players
	setup_player_positions()
	pass
	
static func setup_player_positions():
	if(players.is_empty()):
		return
	angle_step = TAU/players.size()
	for i in range(0,players.size()):
		var tmpPlayer = players[i]
		var angle = PI/2 - angle_step*(i) 
		var pos = GameArea.staticCenterOfScreen +( Vector2(cos(angle)*radius_x, sin(angle)*radius_y) \
		-Vector2(121,121))
		tmpPlayer.position=pos
		pass
	for i in range(1,players.size()):
		print(players[i].position)

static func clear():
	players=[]
	currentPlayer=null

#Default should be the current player, will save time
#Also allowing the choice of drawing from any collection of cards
static func deal_to_player(player:Player=currentPlayer, source=DeckManager.deck):
	var card = DeckManager.draw_card(source)
	player.add_card(card)
	
static func update_current_player(currPlayer=currentPlayer):
	var newPlayerId = (players.find(currentPlayer)+1) % players.size()
	currentPlayer = players[newPlayerId]
	hide_all_other_players_cards_except(currentPlayer)
	start_turn()
	pass	
	
static func 	hide_all_other_players_cards_except(selectedPlayer: Player):
	for player in players:
		if(player!=selectedPlayer):
			player.showCards=false
			player.disable_icon(true)
		else:
			player.showCards=true
			player.disable_icon(false)
		player.queue_redraw()

static func deal_to_all_players(cards: int):
	for i in range(cards):
		for j in range(0,players.size()):
			deal_to_player(players[j])
	print(currentPlayer)
	pass
	
static func start_turn():
	print("Turn of "+currentPlayer.displayPlayer())
	deal_to_player()
	#TO DO : SHOW VISUAL CHANGES ON PLAYER	
	
static func enable_selection(playerList):
	for player in playerList:
		player.get_node("PlayerIcon").disabled=false
		print(player)
	pass
	
static func remove_player(selectedPlayer):
	selectedPlayer.queue_free()
	players.erase(selectedPlayer)
	
	
