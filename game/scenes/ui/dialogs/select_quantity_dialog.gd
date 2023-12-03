extends Dialog

signal quantity(quantity:int)

@onready var sliderQuantity:Slider = $Content/Body/SliderQuantity
@onready var labelQuantity:Label = $Content/Body/LabelQuantity
@onready var labelName:Label = $Content/Body/Top/LabelName
@onready var buttonDrop:Button =$Content/Body/Buttons/ButtonDrop

var _slide_pressed:int = 0
var _just_opened:bool = true
var func_quantity:Callable

func _unhandled_input(event):
	if Input.is_action_just_pressed("cancel"):
		_on_button_cancel_pressed()
		return
	elif Input.is_action_just_pressed("use"):
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

func open(item:Item, all:bool, label:String="Transfert", func_qty=_quantity):
	_just_opened = true
	buttonDrop.text = tr(label)
	labelName.text = tr(item.label)
	func_quantity = func_qty
	sliderQuantity.max_value = item.quantity
	sliderQuantity.value = item.quantity if all else 1
	labelQuantity.text = func_quantity.call(sliderQuantity.value)
	sliderQuantity.grab_focus()
	
func _quantity(value) -> String:
	return str(value)

func _on_slider_quantity_value_changed(value):
	labelQuantity.text = func_quantity.call(value)

func _on_button_cancel_pressed():
	close()

func _on_button_drop_pressed():
	quantity.emit(sliderQuantity.value)
	close()

