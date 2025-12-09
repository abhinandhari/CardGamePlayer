class_name AbstractCard extends Node2D

@export var power:int
@export var title:String
@export var gameMode:String
			
@export var card_size:Vector2


func _ready() -> void:
	card_size=Vector2(150,200)
	gameMode="Abstract"
	title="AbstractCard"
	power=-1023
	print("Abstract Card has been created. Fix Code")
	pass
	
func initialize(x:int):
	setCardProperties(title,x)
	return self
	
func setCardProperties(title:String,pow:int):
	self.title=title
	self.power=pow
	var spr:Sprite2D = get_node("ImageDetails/Art")
	spr.texture = load("res://Sprites/warningImg.jpg")
	print("Abstract Card. No Porperties. Fix")
	pass
	
func perform_action():
	print("The abstract card is performing an action. Oh no. Fix")	
	
func _to_string() -> String:
	return title+" - "+str(power)
	

func get_power() ->int:
	return power

func get_title()-> String:
	return title	

func set_card_size(sprite: Sprite2D, target_size := Vector2(300, 400)):
	if sprite.texture == null:
		print("Add a texture?")
		return
	var tex_size = sprite.texture.get_size()
	var scale_factor = target_size / tex_size
	sprite.scale = scale_factor	
	pass
	
func make_visible( front : bool=true):
	get_node("ImageDetails/Art").visible=front
	get_node("ImageDetails/Back").visible=!front
	return
		
	
