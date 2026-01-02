extends Control

signal perform_transition(text)
signal game_ended(player)

@export var duration:float

func _ready() -> void:
	var gm = GameArea.get_game_mode()
	if gm:
		GameArea.get_game_mode().connect("perform_transition",_perform_transition)
		GameArea.get_game_mode().connect("game_ended",_game_complete)
	else:
		print("NO GM")
	print("Parent above, GM below")
	
func _perform_transition(text,permanent):
	$".".visible=true
	$VBoxContainer/CustomText.text=text
	if(permanent):
		return
	else:
		await get_tree().create_timer(duration).timeout
		$".".visible=false
	
func _game_complete(winnerPlayer:Player):
	print("REACHED GAME END")
	$".".visible=true
	$VBoxContainer/CustomText.text="The Winner is : "+str(winnerPlayer.displayPlayer())
	
	

	
