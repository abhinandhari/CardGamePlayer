class_name AbstractCard extends Node2D

@export var power:int
@export var title:String
@export var gameMode:String

func _ready() -> void:
	gameMode="Abstract"
	title="AbstractCard"
	power=-1023
	print("Abstract Card has been created. Fix Code")
	set_border()
	pass
	
func set_border() ->void:
	hover_border.border_width_all = 4
	hover_border.border_color = Color.WHITE
	hover_border.corner_radius_all = 6	
	
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

func set_card_size(sprite: TextureRect, target_size := Vector2(300, 400)):
	if sprite.texture == null:
		print("Add a texture?")
		return
	var tex_size = sprite.texture.get_size()
	var scale_factor = target_size / tex_size
	sprite.scale = scale_factor	
	print("Sprite")
	print(sprite.texture.get_size())
	$ImageDetails.size=sprite.texture.get_size()*scale_factor+Vector2.ONE*50
	$ImageDetails/Art.position += $ImageDetails.size * scale_factor/16
	$ImageDetails/Back.position += $ImageDetails.size * scale_factor/16
	$Button.size=$ImageDetails.size
	pass
	
func make_visible( front : bool=true):
	get_node("ImageDetails/Art").visible=front
	get_node("ImageDetails/Back").visible=!front
	get_node("Button").visible=front
	return
		
	
func _on_image_details_mouse_entered() -> void:
	if(get_node("ImageDetails/Back").visible):
		return
	$ImageDetails.add_theme_stylebox_override("panel", hover_border)
	print("Hovering over card : "+title)
	pass # Replace with function body.


func _on_image_details_mouse_exited() -> void:
	$ImageDetails.remove_theme_stylebox_override("panel")		
	pass # Replace with function body.
	
var hover_border := StyleBoxFlat.new()
  # optional

 # Replace with function body.


func _on_button_pressed() -> void:
	print("Clicked + "+title)
	pass # Replace with function body.
