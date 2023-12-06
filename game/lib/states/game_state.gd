extends Node

signal saving_start()
signal saving_end()
signal loading_start()
signal loading_end()

var player_state:PlayerState = PlayerState.new()
var inventory = ItemsCollection.new()
var settings = SettingsState.new()
var messages = MessagesList.new()
var quests = QuestsManager.new()

var player:Player
var ui:MainUI
var current_tool:ItemTool
var current_zone:Zone
var savegame_name:String
var use_joypad:bool = false


func _ready():
	use_joypad = Input.get_connected_joypads().size() > 0
	var os_lang = OS.get_locale_language()
	for lang in Settings.langs:
		if (lang == os_lang):
			GameState.settings.lang = lang
	TranslationServer.set_locale(GameState.settings.lang)
	load_game(StateSaver.get_last())

func save_game(savegame = null):
	saving_start.emit()
	StateSaver.set_path(savegame)
	player_state.position = player.position
	player_state.rotation = player.rotation
	StateSaver.saveState(player_state)
	StateSaver.saveState(InventoryState.new(inventory))
	StateSaver.saveState(settings)
	StateSaver.saveState(MessagesState.new(messages))
	StateSaver.saveState(QuestsState.new(quests))
	
	StateSaver.saveState(current_zone.state)
	saving_end.emit()
	
func load_game(savegame = null):
	loading_start.emit()
	StateSaver.set_path(savegame)
	StateSaver.loadState(player_state)
	StateSaver.loadState(InventoryState.new(inventory))
	StateSaver.loadState(settings)
	StateSaver.loadState(MessagesState.new(messages))
	StateSaver.loadState(QuestsState.new(quests))
	loading_end.emit()

func pause_game(blur_screen:bool=true):
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	ui.pause_game(blur_screen)

func resume_game(_dummy=null):
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ui.resume_game()

class InventoryState extends State:
	var inventory:ItemsCollection
	func _init(inventory):
		super("inventory")
		self.inventory = inventory

class MessagesState extends State:
	var messages:MessagesList
	func _init(lessages):
		super("messages")
		self.messages = lessages

class QuestsState extends State:
	var quests:QuestsManager
	func _init(quests):
		super("quests")
		self.quests = quests
