extends AbstractCard

func _ready() -> void:
	print("Created "+title+" with power : "+str(power))
	pass
			
func initialize(x:int):
#ONLY FOR DEV OKI. THIS WILL BE ONLY FOR LOVELETTER
	gameMode="LoveLetter"
	match x:
		1:setCardProperties("Guard",x)
		2:setCardProperties("Sage",x)
		3:setCardProperties("Baron",x)
		4:setCardProperties("HandMaid",x)
		5:setCardProperties("Prince",x)
		6:setCardProperties("King",x)
		7:setCardProperties("Queen",x)
		8:setCardProperties("Princess",x)
		_:setCardProperties("Invalid Card",-1)
	return self
	
func setCardProperties(title:String,pow:int):
#	Target variable I forgot to use, will be for resizing
#	var target_size = Vector2(150, 220)
	self.title=title
	self.power=pow
	position=Vector2(randf_range(-pow*600,pow*600),randf_range(-pow*600,pow*600))
	rotate(pow*20)
	var spr:Sprite2D = get_node("ImageDetails/Art")
	spr.texture = load("res://Sprites/"+gameMode+"/"+title+".jpg")
	print("Loading res://Sprites/"+gameMode+"/"+title+".jpg")
	var backSpr:Sprite2D = get_node("ImageDetails/Back")
	backSpr.texture=load("res://Sprites/"+gameMode+"/CardBack.jpeg")
	set_card_size(spr)
	set_card_size(backSpr)
	pass	
	
	
