extends Dialog

@onready var npc_name = $Panel/VBoxContainer/NPCName
@onready var npc_text = $Panel/VBoxContainer/NPC
@onready var player_text_list = $Panel/VBoxContainer/Player

var talking_char:InteractiveCharacter
var default_answer:int = -1

func open():
	super._open(false)
	var vsize = get_viewport().size / get_viewport().content_scale_factor
	size.x = vsize.x / (3.0 if vsize.x > 1200 else 2.5)
	size.y =  vsize.y / (3.0 if vsize.y > 1200 else 2.5)
	position.x = (vsize.x - size.x) / 2
	position.y = (vsize.y - size.y - 50)

func _unhandled_input(_event):
	if (Dialog.ignore_input()): return
	if (Input.is_action_just_pressed("cancel") and default_answer != -1):
		_on_player_talk_item_clicked(default_answer, null, null)
	elif Input.is_action_just_pressed("accept") and (player_text_list.get_selected_items().size() > 0):
		_on_player_talk_item_clicked(player_text_list.get_selected_items()[0], null, null)

func talk(_char:InteractiveCharacter, phrase:String, answers:Array):
	talking_char = _char
	npc_name.text = str(_char)
	npc_text.text = tr(phrase)
	player_text_list.clear()
	for i in range(0, answers.size()):
		var answer = answers[i]
		if (answer == null): continue
		if (answer is Callable):
			answer = answer.call()
			if (answer == null): continue
		var icon = null
		var index = player_text_list.item_count
		if (answer.size() == 3):
			default_answer = index
			icon = Tools.load_shortcut_icon(Tools.SHORTCUT_CANCEL)
		player_text_list.add_item(tr(answer[0]), icon)
		player_text_list.set_item_metadata(index, i)
	player_text_list.grab_focus()
	if (player_text_list.item_count > 0):
		player_text_list.select(0)

func _on_player_talk_item_clicked(index, _at_position, _mouse_button_index):
	talking_char.answer(player_text_list.get_item_metadata(index))
