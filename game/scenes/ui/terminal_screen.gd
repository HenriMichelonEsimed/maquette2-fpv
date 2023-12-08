extends Dialog

@onready var list_messages:ItemList = $Borders/Screen/Content/Content/Body/MarginContainer/ListMessages
@onready var list_notifications:ItemList = $Borders/Screen/Content/Content/Body/MarginContainer/ListNotifications
@onready var label_message = $Borders/Screen/Content/Content/Body/MarginContainer/LabelMessage
@onready var list_quests = $Borders/Screen/Content/Content/Body/MarginContainer/ListQuests
@onready var label_current = $Borders/Screen/Content/Content/Label
@onready var button_quests:Button = $Borders/Screen/Content/MarginContainer/HBoxContainer/ButtonQuests
@onready var button_messages:Button = $Borders/Screen/Content/MarginContainer/HBoxContainer/ButtonMessages
@onready var button_notifications:Button = $Borders/Screen/Content/MarginContainer/HBoxContainer/ButtonNotifications
@onready var label_left = $Borders/Screen/Content/MarginContainer/HBoxContainer/LabelLeft
@onready var label_right = $Borders/Screen/Content/MarginContainer/HBoxContainer/LabelRight
@onready var label_hour = $Borders/Screen/Content/Top/LabelHour
@onready var label_message2 = $Borders/Screen/Content/Top/LabelMessage
@onready var icon_mail_read = load("res://assets/textures/mail_read.png")
@onready var icon_mail_unread = load("res://assets/textures/mail_unread.png")

var currentButton:Button
var displayMessage = false

func open():
	super._open()
	var ratio = size.y / size.x
	var vsize = get_viewport().size / get_viewport().content_scale_factor
	size.y = vsize.y - 40
	size.x = size.y / ratio
	position.x = (vsize.x - size.x) / 2
	position.y = (vsize.y - size.y) / 2
	label_left.visible = GameState.use_joypad
	label_right.visible = GameState.use_joypad
	var time = Time.get_time_dict_from_system()
	label_hour.text = "%02d:%02d" % [ time.hour, time.minute ]
	label_message2.visible = GameState.messages.have_unread()
	_update()
	_on_button_quests_pressed()
	
func _unhandled_input(event):
	if (ignore_input()): return
	if Input.is_action_just_pressed("cancel"):
		if (displayMessage):
			_on_button_list_messages_pressed()
		else:
			_on_button_back_pressed()
			return
	if Input.is_action_just_pressed("ui_accept" )and list_messages.has_focus() and list_messages.get_selected_items().size() > 0 :
			_on_list_messages_item_clicked(list_messages.get_selected_items()[0], 0, 0)
	if Input.is_action_just_pressed("ui_right"):
		if (currentButton == button_quests):
			_on_button_list_messages_pressed()
		elif (currentButton == button_messages):
			_on_button_notifications_pressed()
	if Input.is_action_just_pressed("ui_left"):
		if (currentButton == button_notifications):
			_on_button_list_messages_pressed()
		elif (currentButton == button_messages):
			_on_button_quests_pressed()

func _update():
	list_notifications.clear()
	for message in NotificationManager.notifications:
		list_notifications.add_item(tr(message))
	list_messages.clear()
	for message in GameState.messages.messages:
		list_messages.add_item(tr(message.subject), icon_mail_read if message.read else icon_mail_unread)
	list_quests.clear()
	list_quests.append_text("[color=yellow]" + tr(GameState.quests.label("main")) + "[/color]\n")
	list_quests.append_text(tr(GameState.quests.current("main").label) + "\n")
	for adv in GameState.quests.get_advpoints("main"):
		if (adv.label != ""):
			list_quests.append_text("\t• [i]" + tr(adv.label) + "[/i]\n")

func _on_button_back_pressed():
	close()
	
func _hide_all():
	list_messages.visible = false
	label_message.visible = false
	list_quests.visible = false
	label_current.visible = false
	list_notifications.visible = false
	displayMessage = false

func _on_button_quests_pressed():
	_hide_all()
	label_current.text = tr("Quests")
	currentButton = button_quests
	list_quests.visible = true
	label_current.visible = true
	list_quests.grab_focus()

func _on_button_list_messages_pressed():
	_hide_all()
	label_current.text = tr("Messages")
	currentButton = button_messages
	list_messages.grab_focus()
	list_messages.visible = true
	label_current.visible = true
	if (list_messages.item_count > 0) and list_messages.get_selected_items().is_empty():
		list_messages.select(0)

func _on_button_notifications_pressed():
	_hide_all()
	label_current.text = tr("Notifications")
	currentButton = button_notifications
	list_notifications.grab_focus()
	list_notifications.visible = true
	label_current.visible = true

func _on_button_home_term_pressed():
	_hide_all()

func _on_list_messages_item_clicked(index, _at_position, _mouse_button_index):
	_hide_all()
	var message = GameState.messages.messages[index]
	message.read = true
	label_current.text = tr("Message")
	label_current.visible = true
	label_message.clear()
	label_message.append_text(tr("From"))
	label_message.append_text(": [color=yellow]" + tr(message.from) + "[/color]\n")
	label_message.append_text(tr("Subject"))
	label_message.append_text(": [color=yellow]" + tr(message.subject) + "[/color]\n")
	label_message.append_text(tr(message.message))
	message.read = true
	label_message.visible = true
	GameState.quests.event_all(Quest.QuestEventType.QUESTEVENT_READMESSAGE, message.key)
	_update()
	displayMessage = true
