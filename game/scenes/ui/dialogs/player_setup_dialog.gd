extends Dialog

@onready var button_close = $Background/Borders/Content/Top/ButtonClose
@onready var button_save = $Background/Borders/Content/Panel/Margin/Form/Buttons/ButtonSave
@onready var edit_name = $Background/Borders/Content/Panel/Margin/Form/Name/EditName
@onready var player_1 = $"Background/Borders/Content/Panel/Margin/Form/Char/Panel1/Player1/3DView/InsertPoint/Character"
@onready var player_2 = $"Background/Borders/Content/Panel/Margin/Form/Char/Panel2/Player2/3DView/InsertPoint/Character"
@onready var panel_1 = $Background/Borders/Content/Panel/Margin/Form/Char/Panel1
@onready var panel_2 = $Background/Borders/Content/Panel/Margin/Form/Char/Panel2

var style_1:StyleBoxFlat
var style_2:StyleBoxFlat
var color_selected = Color(0, 0, 0, 128)
var color_unselected = Color(0, 0, 0, 0)

func _input(event):
	if (Dialog.ignore_input()): return
	if ((event is InputEventJoypadButton) or (event is InputEventKey)) and (not event.pressed):
		if (Input.is_action_just_released("cancel")):
			close()

func open():
	super._open()
	GameState.prepare_game(false)
	edit_name.text = GameState.player_state.nickname
	style_1 = panel_1.get_theme_stylebox("panel").duplicate()
	style_1.bg_color = color_unselected
	panel_1.add_theme_stylebox_override("panel", style_1)
	style_2 = panel_2.get_theme_stylebox("panel").duplicate()
	style_2.bg_color = color_unselected
	panel_2.add_theme_stylebox_override("panel", style_2)
	player_1.get_node("AnimationPlayer").play(Consts.ANIM_WALKING)
	player_2.get_node("AnimationPlayer").play(Consts.ANIM_WALKING)
	

func set_shortcuts():
	Tools.set_shortcut_icon(button_close, Tools.SHORTCUT_CANCEL)

func _on_button_save_pressed():
	#GameState.player.set_y_axis()
	close()


func _on_panel_1_focus_entered():
	pass # Replace with function body.
