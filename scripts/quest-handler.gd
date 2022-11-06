extends CanvasItem


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var quests
var active_card
var active_quest
var quest_time = 1
var quest_started = false
var rng = RandomNumberGenerator.new()
var coin_flip

onready var timer = get_node("Timer")
onready var quest_progress_bar = get_node("ProgressBar")
onready var quest_description = get_node("QuestDescription")
onready var start_button = get_node("StartButton")
onready var close_button = get_node("CloseButton")

onready var country_usa = get_node("../../USA/Name")
onready var country_canada = get_node("../../CANADA/Name")

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var data = File.new();
	data.open("res://cards.json", File.READ)

	var json = JSON.parse(data.get_as_text())
	if (!typeof(json.result) == TYPE_DICTIONARY):
		return

	quests = json.result["quests"]
	print("Quests: ", quests);
	
	if (active_card == null):
		set_visible(false)
		quest_progress_bar.set_visible(false)
		start_button.set_visible(true)
		close_button.set_visible(false)

func open_panel(card):
	active_card = card
	var selected_country = get_node("/root/Map").selected_country
	for quest in quests:
		if (
			quest["for_id"] == active_card["id"] &&
			quest["location"] == selected_country &&
			card["level"] >= quest["required_level"]
		):
			active_quest = quest
			break
	if (active_quest == null):
		return
	
	set_visible(true)
	print(active_quest)
	get_node("CardName").text = str("For: ", active_card["name"])
	get_node("QuestTitle").text = str("Quest: ", active_quest["name"])
	quest_description.text = str(active_quest["description"])
	start_button.connect("pressed", self, "_start_quest_pressed")
	start_button.set_visible(true)
	close_button.set_visible(false)
	
func _start_quest_pressed():
	quest_progress_bar.set_visible(true)
	timer.wait_time = active_quest["time"]
	timer.start()
	quest_started = true

func _close_button_pressed():
	set_visible(false)

func _process(delta):
	rng.randf() # fix getting same random number every time for some reason
	if (active_quest != null):
		quest_progress_bar.value = 100 - (timer.time_left / active_quest["time"]) * 100
		if (quest_started == true && quest_progress_bar.value == 100):
			quest_progress_bar.set_visible(false)
			coin_flip = rng.randf() > 0.15;
			print("Win/loss: ", coin_flip)
			if (coin_flip):
				quest_description.text = active_quest["success"]
				level_up(active_quest, active_card)
			else:
				quest_description.text = active_quest["failure"]
			
			active_card = null
			active_quest = null
			quest_started = false
			
			start_button.set_visible(false)
			close_button.set_visible(true)
			close_button.connect("pressed", self, "_close_button_pressed")

func level_up(quest, card):
	if quest["type"] == "level-up":
		card["level"] += 1
		var country_node = get_node(str("/root/Map/", quest["location"], "/Name"))
		if card["type"] == "Scientist":
			country_node.remove_insecurity()
		elif card["type"] == "Politician":
			country_node.add_reputation()
		elif card["type"] == "Celebrity":
			country_node.add_reputation()
	print("Leveled up card: ", card)
	get_node("../DeckPanel/DeckHolder").update_card(card["id"], card)
	get_node("/root/Map").check_win_state()
