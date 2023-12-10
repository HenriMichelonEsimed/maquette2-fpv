extends InteractiveCharacter

func _init():
	var d1 = []
	d1.append_array([
		["Congratulation, you won the game !!", a1], [
			["Wow, thank you !", [
				"You can now roam freely in this area or in the station", [
					["Let's talk", d1],
					["Nice. Bye", _end, true]
				]
			]],
			["Ok, bye", _end, true]
		]
	])
	super(
		["Hello", [
			["Hello, nice to meet you", d1]
		]]
	)

func a1():
	GameState.quests.event(Quest.QuestEventType.QUESTEVENT_TALK, "QMain1_end")
