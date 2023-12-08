extends Dialog

@onready var i18n = $Background/Borders/Content/Panel/Borders/Settings/i18n/OptionButton

func _unhandled_input(event):
	if (ignore_input()): return
	if (Input.is_action_just_pressed("cancel")):
		close()

func open():
	super._open()
	for i in range(0, i18n.item_count):
		if (Settings.langs[GameState.settings.lang] == i18n.get_item_text(i)):
			i18n.select(i)
	i18n.grab_focus()

func _on_button_save_pressed():
	var item = i18n.get_item_text(i18n.selected)
	for lang in Settings.langs:
		if (Settings.langs[lang] == item):
			GameState.settings.lang = lang
			TranslationServer.set_locale(lang)
	close()
