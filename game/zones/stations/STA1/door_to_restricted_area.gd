extends Usable

func _init():
	super._init(false)

func _check_use() -> bool:
	if not super._check_item_use("You need an access card", "Door open", [[Item.ItemType.ITEM_QUEST, "access_card_1"]]): 
		GameState.quests.advpoint("lvl0_door_to_restricted_area_access_card")
		return false
	else:
		GameState.quests.finish_advpoint("lvl0_use_access_card")
		return true

func _use():
	$"../..".change_zone.emit("exteriors/EXT1/level_1")
