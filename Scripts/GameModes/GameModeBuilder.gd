class_name GameModeBuilder extends Node

@export var gameModeName:String
@export var minPlayerCount:int
@export var maxPlayerCount:int

static func build_game_mode(name:String) -> AbstractGameMode:
	match name:
		"LoveLetter":
			return LoveLetterMode.new()
		_:
			return DevMode.new()
	pass
