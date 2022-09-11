extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selected_country

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func select_country(country):
	selected_country = country
	for node in get_children():
		if !(node is TileMap):
			continue
		if node.name == selected_country:
			node.get_child(0).set("custom_colors/font_color", "#c11515")
		else:
			node.get_child(0).set("custom_colors/font_color", "#ffffff")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
