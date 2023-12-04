extends Node

signal saving_start()
signal saving_end()
signal loading_start()
signal loading_end()

var player_state:PlayerState = PlayerState.new()
var inventory = ItemsCollection.new()
var settings = SettingsState.new()

var player:Player
var current_tool:ItemTool
var current_zone:Zone
var savegame_name:String

func _ready():
	loadGame(StateSaver.get_last())

func saveGame(savegame = null):
	saving_start.emit()
	StateSaver.set_path(savegame)
	player_state.position = player.position
	player_state.rotation = player.rotation
	StateSaver.saveState(player_state)
	StateSaver.saveState(InventoryState.new(inventory))
	StateSaver.saveState(settings)
	saving_end.emit()
	
func loadGame(savegame = null):
	loading_start.emit()
	StateSaver.set_path(savegame)
	StateSaver.loadState(player_state)
	StateSaver.loadState(InventoryState.new(inventory))
	StateSaver.loadState(settings)
	loading_end.emit()

class InventoryState extends State:
	var inventory:ItemsCollection
	func _init(inventory):
		super("inventory")
		self.inventory = inventory
