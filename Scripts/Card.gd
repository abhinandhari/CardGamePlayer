class_name AbstractCard extends Node2D
#This class needs documentation as I am bound by my ability to code.
#CardState should be considered 0 if IDLE, 1 if played. This is a strict logic I am using and I know will affect scalability.
@export var power:int
@export var displayText:String
var cardType
@export var hover_scale: Vector2 = Vector2.ONE
@export var tween_duration := 0.25
var cardState
var _scale:Vector2
var _tween: Tween
var _position

signal playing_card(player)

func _ready() -> void:
	displayText="AbstractCard"
	power=-1023
	print("Abstract Card has been created. Fix Code")
	pass
	
func initialize(x:int):
	setCardProperties(displayText,x)
	return self
	
func setCardProperties(displayText:String,pow:int):
	self.displayText=displayText
	self.power=pow
	var spr:Sprite2D = get_node("ImageDetails/Art")
	spr.texture = load("res://Sprites/warningImg.jpg")
	print("Abstract Card. No Properties. Fix")
	pass
	
#This is a bad method to store sizes and positions imo. Novice game developer moment.
func store_original_data():
	_scale=scale
	_position=position
	
func perform_action():
	print("The abstract card is performing an action. Oh no. Fix")	
	
func _to_string() -> String:
	return displayText+" - "+str(power)
	

func get_power() ->int:
	return power

func get_displayText()-> String:
	return displayText	

func set_card_size(sprite: TextureRect, target_size := Vector2(300, 400)):
	if sprite.texture == null:
		print("Add a texture?")
		return
	var tex_size = sprite.texture.get_size()
	var scale_factor = target_size / tex_size
	sprite.scale = scale_factor	
	$ImageDetails.size=sprite.texture.get_size()*scale_factor+Vector2.ONE*50
	$ImageDetails/Art.position += $ImageDetails.size * scale_factor/16
	$ImageDetails/Back.position += $ImageDetails.size * scale_factor/16
	#$Button.size=$ImageDetails.size
	pass
	
func make_visible( front : bool=true):
	get_node("ImageDetails").disabled=!front
	get_node("ImageDetails/Art").visible=front
	get_node("ImageDetails/Back").visible=!front
	return
		
func scale_to(target_scale:Vector2=_scale):
	if _tween and _tween.is_running():
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(
		self,
		"scale",
		target_scale,
		tween_duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)			
	if(target_scale>_scale):
		z_index=5
		_tween.parallel().tween_property(self, "position", 200*Vector2.UP, tween_duration)
	else:
		z_index=0
		_tween.parallel().tween_property(self, "position", _position, tween_duration)
		

func _on_image_details_mouse_entered() -> void:
	if(get_node("ImageDetails/Back").visible || $ImageDetails.disabled):
		return
	print("Hovering over card : "+displayText)
	store_original_data()
	scale_to(hover_scale)
	pass # Replace with function body.


func _on_image_details_mouse_exited() -> void:
	if(get_node("ImageDetails/Back").visible || $ImageDetails.disabled):
		return
	scale_to()
	pass # Replace with function body.
  # optional

 # Replace with function body.

func _on_image_details_pressed() -> void:
	print("Clicked the details")
	play_card()
	pass # Replace with function body.
	
func play_card():
	print("Playing Card : " + displayText)
	print(get_parent())
	$ImageDetails.disabled=true
	scale_to()
	emit_signal("playing_card",self,get_parent())
	
