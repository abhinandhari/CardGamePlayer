extends Control

var isVisible=true
@export var requiresPlayerNames:bool =false
var columnCount=1
@onready var grid_container =$DiscardContainer/ScrollContainer/AllCards

func _ready() -> void:
	GameArea.get_game_mode().to_discard_pile_node.connect(modify_discard_node)
	pass

func modify_discard_node(playerCount,playerNameRequired):
	$DiscardContainer/ScrollContainer/AllCards.set_columns(playerCount)
	requiresPlayerNames=	playerNameRequired
	if(playerNameRequired):
		for i in range(playerCount):
			var playerLabel = Label.new()
			playerLabel.set_text(PlayerManager.players.get(i).displayPlayer())
			playerLabel.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
			grid_container.add_child(playerLabel)
	
func _on_view_discard_pile_pressed() -> void:
	$DiscardContainer.visible=isVisible
	isVisible=!isVisible
	pass # Replace with function body.

func add_to_pile(card:AbstractCard,player):
	#WRAPPER CREATED AS CARD IS A NODE, NOT A CONTROL
	card.make_visible(true)
	var wrapper := Control.new()
	wrapper.custom_minimum_size = Vector2(50, 100)
	wrapper.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wrapper.size_flags_vertical = Control.SIZE_EXPAND_FILL
	grid_container.add_child(wrapper)
	card.reparent(wrapper)
	card.position=wrapper.size/2
	card.position.y-=40
	print_tree_pretty()
	pass
