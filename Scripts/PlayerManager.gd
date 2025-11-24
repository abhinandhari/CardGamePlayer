class_name PlayerManager extends Node

func _ready() -> void:
	print("Player Manager has been created")

static var players:Array[Player]=[]
static var currentPlayer:Player

static func add_player(player : Player):
	if(currentPlayer==null):
		currentPlayer=player
	players.append(player)
	pass

static func clear():
	players=[]
	currentPlayer=null
	
