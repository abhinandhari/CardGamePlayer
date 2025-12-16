class_name PlayerManager extends Node

func _ready() -> void:
	print("Player Manager has been created")

static var players:Dictionary = {}
static var currentPlayer: Player :
	get:
		return currentPlayer
	set(value):
		currentPlayer = value
		currentPlayer.showCards=true
		print("Current player changed:", value)
static var angle_step #Used to position the players
static var radius_x:float = 800
static var radius_y:float = 400
const playerScene = preload("res://Scenes/player.tscn")

func get_players():
	return players.values()
	
static func create_players(parent:Node,count : int): #Circumvent godot scene creation
	for i in range(1,count+1):
		var newPlayer = playerScene.instantiate()
		newPlayer.id=i
		if(currentPlayer==null):
			currentPlayer=newPlayer
		parent.add_child(newPlayer)
		players.get_or_add(i,newPlayer)
	#position the players
	setup_player_positions()
	pass
	
static func setup_player_positions():
	if(players.is_empty()):
		return
	angle_step = TAU/players.size()
	for i in range(players.size()):
		var tmpPlayer = players.get(i+1)
		var angle = PI/2 - angle_step*i 
		var pos = GameArea.staticCenterOfScreen +( Vector2(cos(angle)*radius_x, sin(angle)*radius_y) \
		-Vector2(121,121))
		tmpPlayer.position=pos
		pass
	for i in range(1,players.size()+1):
		print(players.get(i).position)

static func clear():
	players={}
	currentPlayer=null

#Default should be the current player, will save time
#Also allowing the choice of drawing from any collection of cards
static func deal_to_player(player:Player=currentPlayer, source=DeckManager.deck):
	var card = DeckManager.draw_card(source)
	player.add_card(card)
	
static func update_current_player(currPlayer=currentPlayer):
	var newPlayerId = (currentPlayer.id+1) % players.size()
	if(newPlayerId==0):
		newPlayerId=players.size()
	currentPlayer = players.get(newPlayerId)
	hide_all_other_players_cards_except(currentPlayer)
	pass	
static func 	hide_all_other_players_cards_except(selectedPlayer: Player):
	for player in players.values():
		if(player!=selectedPlayer):
			player.showCards=false
		else:
			player.showCards=true


static func deal_to_all_players(cards: int):
	for i in range(cards):
		for j in range(1,players.size()+1):
			deal_to_player(players.get(j))
	print(currentPlayer)
	pass
	
static func start_turn():
	print("Turn of "+str(currentPlayer))
	#TO DO : SHOW VISUAL CHANGES ON PLAYER	
