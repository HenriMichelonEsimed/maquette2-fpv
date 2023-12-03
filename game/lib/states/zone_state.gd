class_name ZoneState extends State

var items_removed:PackedStringArray = PackedStringArray()
var items_added:ItemsCollection = ItemsCollection.new(false)

func _init(name:String, parent:Node=null):
	super(name, parent)
