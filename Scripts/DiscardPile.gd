extends Control

var isVisible=true
@export var requiresPlayerNames:bool =false

func _ready() -> void:
	pass

func _on_view_discard_pile_pressed() -> void:
	$DiscardContainer.visible=isVisible
	isVisible=!isVisible
	pass # Replace with function body.

func add_to_pile(card,player):
	print("TTT Reached Here")
	var playerNamesNode = $DiscardContainer/VBoxContainer
	var nodeToAddValues = $DiscardContainer/VBoxContainer/AllCards
	if(requiresPlayerNames):
		playerNamesNode.add_child(player)
	nodeToAddValues.add_child(card)
	print(nodeToAddValues)
	pass
