extends Dialog



@onready var sliderQuantity:Slider = $Content/Body/SliderQuantity
@onready var labelQuantity:Label = $Content/Body/LabelQuantity
@onready var labelName:Label = $Content/Body/Top/LabelName
@onready var buttonDrop:Button =$Content/Body/Buttons/ButtonDrop

var _slide_pressed:int = 0
var quantity_tostring:Callable
var quantity:Callable

func _unhandled_input(event):
	if (ignore_input()): return
	if Input.is_action_just_pressed("cancel"):
		_on_button_cancel_pressed()
		return
	elif Input.is_action_just_pressed("ui_accept"):
		_on_button_drop_pressed()
		return
	if sliderQuantity.has_focus():
		if (_slide_pressed > 10):
			if Input.is_action_pressed("ui_left"):
				sliderQuantity.value -= 2
			elif Input.is_action_pressed("ui_right"):
				sliderQuantity.value += 2
		else :
			if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				_slide_pressed += 1
		if Input.is_action_just_released("ui_left"):
			sliderQuantity.value -= 1
			_slide_pressed = 0
		elif Input.is_action_just_released("ui_right"):
			sliderQuantity.value += 1
			_slide_pressed = 0

func open(item:Item, all:bool, qty:Callable, label:String="Transfert", qty_str:Callable=_quantity_tostring):
	super._open()
	buttonDrop.text = tr(label)
	labelName.text = tr(item.label)
	quantity_tostring = qty_str
	quantity = qty
	sliderQuantity.max_value = item.quantity
	sliderQuantity.value = item.quantity if all else 1
	labelQuantity.text = quantity_tostring.call(sliderQuantity.value)
	sliderQuantity.grab_focus()
	
func _quantity_tostring(value) -> String:
	return str(value)

func _on_slider_quantity_value_changed(value):
	labelQuantity.text = quantity_tostring.call(value)

func _on_button_cancel_pressed():
	close()

func _on_button_drop_pressed():
	quantity.call(sliderQuantity.value)
	close()

