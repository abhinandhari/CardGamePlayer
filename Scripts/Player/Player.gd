class_name Player extends Node

var hand : Array[AbstractCard] = []
var id :int

func _ready() -> void:
	print("Created Player : "+str(id))
	
func add_card(card):
	card.location="HAND"
	hand.append(card)
	print("Player "+str(id)+" : "+str(hand))
	display_hand()
	
func set_id(id:int)->void:
	self.id=id
	
func display_hand()->void:
	# Remove previous cards
	for child in get_children():
		child.queue_free()
	# Arrange cards horizontally
	var spacing = 120
	for i in range(hand.size()):
		var card_instance = hand[i].duplicate()
		card_instance.position = Vector2(330+i * spacing, 900)
		add_child(card_instance)
	
func _to_string()->String:
		return "Player "+str(id)
