class_name StartScreen extends Node2D
@onready var game_scene = "res://Scenes/game_area.tscn"
@onready var listOfModes:Array[AbstractGameMode]
@onready var gameOptionsNode :OptionButton = $"OptionsContainer/GameMode/OptionButton"
@onready var playerCountOptionsNode :OptionButton = $"OptionsContainer/PlayerCount/OptionButton"

func _ready() -> void:
	create_game_modes_option()
	self.global_position = get_viewport().get_visible_rect().size / 2
	pass	

#TODO : ADD A GAMEMODE IN THE FUTURE
func _on_start_pressed() -> void:
	var packed = load(game_scene)
	var scene :GameArea = packed.instantiate()
	scene.gameMode = listOfModes[gameOptionsNode.selected]
	scene.playerCount=int(playerCountOptionsNode.get_item_text(playerCountOptionsNode.selected))
#	add values to the game scene and then start scene
	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene=scene
	pass # Replace with function body.
	
func create_game_modes_option():
	listOfModes = build_game_modes()
	for i in range(listOfModes.size()):
		var displayText:String = listOfModes[i].gameModeName.replace('_',' ')
		gameOptionsNode.add_item(displayText,i)
	set_default_game_mode()
	print(listOfModes)
	pass

func set_default_game_mode():
	gameOptionsNode.select(0)
	create_player_options_for_game_mode(listOfModes[0])
	pass
	
func build_game_modes()->Array[AbstractGameMode]:
	var listOfModes:Array[AbstractGameMode]
	listOfModes.append(GameModeBuilder.build_game_mode("LoveLetter"))
	listOfModes.append(GameModeBuilder.build_game_mode("DEV"))
	return listOfModes	

func _on_selecting_game_mode(index: int) -> void:
	create_player_options_for_game_mode(listOfModes[index])
	pass # Replace with function body.
	
func create_player_options_for_game_mode(gameMode:AbstractGameMode)	:
	playerCountOptionsNode.clear()
	for i in range(gameMode.minPlayerCount,gameMode.maxPlayerCount+1):
		playerCountOptionsNode.add_item(str(i),i)
	playerCountOptionsNode.select(0)
	pass


func _on_selecting_player_count(index: int) -> void:
	pass # Replace with function body.
