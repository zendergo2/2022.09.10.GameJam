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
	for quest in quests:
		if (quest["for_id"] == card["id"]):
			active_quest = quest
			break
	
	set_visible(true)
	print(active_quest)
	get_node("CardName").text = str("For: ", card["name"])
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

func _process(delta):
	rng.randf() # fix getting same random number every time for some reason
	if (active_quest != null):
		quest_progress_bar.value = 100 - (timer.time_left / active_quest["time"]) * 100
		if (quest_started == true && quest_progress_bar.value == 100):
			quest_progress_bar.set_visible(false)
			coin_flip = rng.randf() > 0.5;
			print("Win/loss: ", coin_flip)
			if (coin_flip):
				quest_description.text = active_quest["success"]
			else:
				quest_description.text = active_quest["failure"]
			active_quest = null
			quest_started = false
			
			start_button.set_visible(false)
			close_button.set_visible(true)
			close_button.connect("pressed", self, "_close_button_pressed")

func _close_button_pressed():
	set_visible(false)
