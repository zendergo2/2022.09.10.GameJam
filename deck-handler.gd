extends CanvasItem


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cards
var quest_panel

# Called when the node enters the scene tree for the first time.
func _ready():
	quest_panel = get_node("../../QuestPanel")
	print(quest_panel)
	var data = File.new();
	data.open("res://cards.json", File.READ)

	var json = JSON.parse(data.get_as_text())
	if (!typeof(json.result) == TYPE_DICTIONARY):
		return
	
	cards = json.result['cards'];
#	print("Cards: ", cards)

	print_cards()

func _card_pressed(card):
	print("click ", card)
	quest_panel.open_panel(card)

func update_card(id, card):
	var found_card
	for c in cards:
		if (c["id"] == id):
			found_card = c
			break
	
	if (found_card != null):
		cards[cards.find(found_card)] = card
	print_cards()

func print_cards():
	for node in get_children():
		remove_child(node)
		node.queue_free()
	
	for card in cards:
		var card_button = Button.new()
		card_button.set_text(str(card["type"], ": ", card["name"], " (Level: ", card["level"], ")"))
		card_button.connect("pressed", self, "_card_pressed", [card])
		add_child(card_button)
		print("Adding card: ", card)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
