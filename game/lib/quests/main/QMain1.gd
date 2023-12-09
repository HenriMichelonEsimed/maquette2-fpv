extends QuestGoal

var end = false

func _init():
	super("QMain1", "QMain0",
	"Meet the Mysterious Person is the Restricted Area")

func _restart():
	CraftingRecipes.add_recipe("ham_sandwich_pickles_1", [ Item.ItemType.ITEM_CONSUMABLES, [
		"ham_sandwich_1", "pickle_1", "pickle_1"
	]])

func on_new_quest_event(type:Quest.QuestEventType, event_key:String):
	if (type == Quest.QuestEventType.QUESTEVENT_TALK) and (event_key == "QMain1_end"):
		end = true

func success():
	if (end): return "QMainZ"
