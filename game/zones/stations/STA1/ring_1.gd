extends ItemQuest

func collect():
	$"../administrator_1".interact($"../administrator_1".ring_discussion(self))
	return false
