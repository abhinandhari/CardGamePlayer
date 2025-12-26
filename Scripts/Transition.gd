extends Control

@export var duration:float
func _ready() -> void:
	var gm = GameArea.get_game_mode()
	if gm:
		GameArea.get_game_mode().connect("perform_transition",_perform_transition)
	else:
		print("NO GM")
	print("Parent above, GM below")
	
func _perform_transition(text):
	pass
	#$".".visible=true
	#$VBoxContainer/CustomText.text=text
	#await get_tree().create_timer(duration).timeout
	#$".".visible=false
	#print("Reached here")
	
