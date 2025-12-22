extends AbstractCard

func _ready() -> void:
	print("Created "+displayText+" with power : "+str(power))
	pass
			
func initialize(x:int):
	match x:
		1:
			setCardProperties("Guard",x)
			cardType=LoveLetterMode.CardType.GUARD
		2:	
			setCardProperties("Sage",x)
			cardType=LoveLetterMode.CardType.SAGE
		3:
			setCardProperties("Baron",x)
			cardType=LoveLetterMode.CardType.BARON
		4:
			setCardProperties("HandMaid",x)
			cardType=LoveLetterMode.CardType.HANDMAID
		5:
			setCardProperties("Prince",x)
			cardType=LoveLetterMode.CardType.PRINCE
		6:
			setCardProperties("King",x)
			cardType=LoveLetterMode.CardType.KING
		7:
			setCardProperties("Queen",x)
			cardType=LoveLetterMode.CardType.QUEEN
		8:
			setCardProperties("Princess",x)
			cardType=LoveLetterMode.CardType.PRINCESS
		_:setCardProperties("Invalid Card",-1)
	return self
	
func setCardProperties(displayText:String,pow:int):
	#Love Letter only needs to call this once, hence the last make_visible() in this function
#	Target variable I forgot to use, will be for resizing
#	var target_size = Vector2(150, 220)
	self.displayText=displayText
	self.power=pow
	position=Vector2(randf_range(-pow*600,pow*600),randf_range(-pow*600,pow*600))
	rotate(pow*20)
	var spr:TextureRect = get_node("ImageDetails/Art")
	spr.texture = load("res://Sprites/LoveLetter/"+displayText+".jpg")
	print("Loading res://Sprites/LoveLetter/"+displayText+".jpg")
	var backSpr:TextureRect = get_node("ImageDetails/Back")
	backSpr.texture=load("res://Sprites/LoveLetter/CardBack.jpeg")
	set_card_size(spr)
	set_card_size(backSpr)
	make_visible(false)
	store_original_data()
	pass	

func play_card()-> void :
	super()
	pass

	
	
