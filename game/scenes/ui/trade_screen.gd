extends Dialog

class TradeScreenState extends State:
	var tab:int = 0
	func _init():
		super("trade_screen")

@onready var tabs:TabContainer = $Panel/Content/Body/Content/Tabs
@onready var list_tools:ItemList = $Panel/Content/Body/Content/Tabs/Tools/List
@onready var list_consumables:ItemList = $Panel/Content/Body/Content/Tabs/Consumables/List
@onready var list_quest:ItemList = $Panel/Content/Body/Content/Tabs/Quests/List
@onready var list_miscellaneous:ItemList = $Panel/Content/Body/Content/Tabs/Miscellaneous/List
@onready var item_content = $Panel/Content/Body/Content/PanelItem/Content
@onready var item_title = $Panel/Content/Body/Content/PanelItem/Content/Title
@onready var price_value = $Panel/Content/Body/Content/PanelItem/Content/LabelPrice
@onready var node_3d = $"Panel/Content/Body/Content/PanelItem/Content/ViewContent/3DView/InsertPoint"
@onready var label_credits = $Panel/Content/Bottom/Menu/Label

var on_trade_end:Callable

const tab_order = [
	Item.ItemType.ITEM_TOOLS,
	Item.ItemType.ITEM_CONSUMABLES,
	Item.ItemType.ITEM_MISCELLANEOUS,
	Item.ItemType.ITEM_QUEST
]

@onready var list_content = {
	Item.ItemType.ITEM_TOOLS : list_tools,
	Item.ItemType.ITEM_CONSUMABLES : list_consumables,
	Item.ItemType.ITEM_MISCELLANEOUS : list_miscellaneous,
	Item.ItemType.ITEM_QUEST : list_quest
}

var state = TradeScreenState.new()
var trader:InteractiveCharacter
var item:Item
var list:ItemList
var selected = 0
var credits = 0
var item_credits:ItemMiscellaneous
var prev_tab = -1

func open(char:InteractiveCharacter, on_trade_end):
	super._open()
	self.on_trade_end = on_trade_end
	var ratio = size.x / size.y
	var vsize = get_viewport().size / get_viewport().content_scale_factor
	size.x = vsize.x / (1.5 if vsize.x > 1200 else 1.2)
	size.y = size.x / ratio
	position.x = (vsize.x - size.x) / 2
	position.y = (vsize.y - size.y) / 2
	tabs.custom_minimum_size.x = size.x/2
	StateSaver.loadState(state)
	item_content.visible = false
	trader = char
	item_credits = GameState.inventory.get_credits()
	if (item_credits != null):
		credits = item_credits.quantity
	_refresh()
	_hide_empty_tabs()

func _input(event):
	if Input.is_action_just_pressed("cancel"):
		_on_button_back_pressed()
		return
	#elif Input.is_action_just_pressed("ui_accept"):
	#	_on_buy_pressed()
	#	return
	state.tab = tabs.current_tab
	if Input.is_action_just_pressed("ui_left"):
		_prev_tab()
	elif Input.is_action_just_pressed("ui_right"):
		_next_tab()

func _on_button_back_pressed():
	close()
	on_trade_end.call()

func _on_list_tools_item_selected(index):
	list_consumables.deselect_all()
	list_miscellaneous.deselect_all()
	list_quest.deselect_all()
	_item_details(trader.items.getone_bytype(index, Item.ItemType.ITEM_TOOLS), index)

func _on_list_miscellaneous_item_selected(index):
	list_consumables.deselect_all()
	list_quest.deselect_all()
	list_tools.deselect_all()
	_item_details(trader.items.getone_bytype(index, Item.ItemType.ITEM_MISCELLANEOUS), index)

func _on_list_item_quest_selected(index):
	list_consumables.deselect_all()
	list_miscellaneous.deselect_all()
	list_tools.deselect_all()
	_item_details(trader.items.getone_bytype(index, Item.ItemType.ITEM_QUEST), index)

func _on_list_item_consumable_selected(index):
	list_miscellaneous.deselect_all()
	list_quest.deselect_all()
	list_tools.deselect_all()
	_item_details(trader.items.getone_bytype(index, Item.ItemType.ITEM_CONSUMABLES), index)

func _item_details(_item:Item, index):
	selected = index
	item = _item
	item_title.text = item.label
	price_value.text = tr("Unit price : %.2f") % _item.price
	Tools.show_item(_item, node_3d)
	item_content.visible = true

func _next_tab():
	for idx in range(tabs.current_tab+1, tabs.get_tab_count()):
		if not tabs.is_tab_hidden(idx):
			tabs.current_tab = idx
			return

func _prev_tab():
	for idx in range(tabs.current_tab-1, -1, -1):
		if not tabs.is_tab_hidden(idx):
			tabs.current_tab = idx
			return

func _fill_list(idx: int, type:Item.ItemType, list:ItemList):
	list.clear()
	for trade_item in trader.items.getall_bytype(type):
		list.add_item(tr(str(trade_item)))
	if (list.item_count == 0):
		tabs.set_tab_hidden(idx, true)
		
func _hide_empty_tabs():
	for i in range(0, tabs.get_tab_count()):
		if not tabs.is_tab_hidden(i):
			state.tab = i
			break
	tabs.current_tab = state.tab

func _refresh():
	item_content.visible = false
	label_credits.text =tr("Inventory : %d credits" if credits > 1 else "Inventory : %d credit")  % credits
	var idx = 0
	for type in list_content:
		_fill_list(idx, type, list_content[type])
		idx += 1
	if (tabs.is_tab_hidden(tabs.current_tab)):
		_hide_empty_tabs()
	_focus_current_tab()

func _buy_quanity(value):
	return tr("%d (%d credits)") % [value, item.price * value]

func _on_buy_pressed():
	if (item == null): return
	if (item is ItemMultiple):
		var select_dialog = Tools.load_dialog(self, Tools.DIALOG_SELECT_QANTITY, _focus_current_tab)
		select_dialog.open(item, false, _buy, "Buy")
	else:
		_buy()

func _buy(quantity:int=0):
	var price = quantity * item.price
	if price > credits:
		var alert_dialog = Tools.load_dialog(self, Tools.DIALOG_ALERT, _focus_current_tab)
		alert_dialog.open("Buy", "You don't have enough credits")
		return
	if (price > 0):
		credits -= price
		var remove_credit = item_credits.duplicate()
		remove_credit.quantity = price
		GameState.inventory.remove(remove_credit)
	var buy_item
	if item is ItemMultiple:
		buy_item = item.duplicate()
		buy_item.quantity = quantity
	else:
		buy_item = item
	GameState.inventory.add(buy_item)
	trader.items.remove(buy_item)
	GameState.quests.event_all(Quest.QuestEventType.QUESTEVENT_BUY, item.key)
	_refresh()

func _focus_current_tab():
	list = list_content[tab_order[tabs.current_tab]]
	list.grab_focus()
	if (list.item_count > 0) and not list.is_anything_selected():
		list.select(0)
		list.item_selected.emit(0)

func _on_tabs_tab_selected(tab):
	if (prev_tab == tab): return
	prev_tab = tab
	item_content.visible = false
	_focus_current_tab()
	state.tab = tab
	StateSaver.saveState(state)
