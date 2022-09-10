extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var x_speed = 1_000;
export var y_speed = 1_000;
export var zoom_step = 1.1;

# Called when the node enters the scene tree for the first time.
func _ready():
	print(x_speed, y_speed)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pan_camera(delta)
	pass

func pan_camera(delta):
	var camera_dir = Vector2.ZERO;
	if (Input.is_action_pressed("move_down")):
		camera_dir.y += 1
	if (Input.is_action_pressed("move_up")):
		camera_dir.y -= 1
	if (Input.is_action_pressed("move_left")):
		camera_dir.x -= 1
	if (Input.is_action_pressed("move_right")):
		camera_dir.x += 1
	
	if (camera_dir != Vector2.ZERO):
		camera_dir = camera_dir.normalized()
	
	camera_dir.x *= x_speed * delta
	camera_dir.y *= y_speed * delta
	
	set_offset(get_offset() + camera_dir)
	pass

# https://godotengine.org/qa/25983/camera2d-zoom-position-towards-the-mouse?show=26109#a26109
func _input(event):
	if event is InputEventMouse:
		if event.is_pressed() and not event.is_echo():
			var mouse_position = event.position

			if event.button_index == BUTTON_WHEEL_UP:
				zoom_at_point(1/zoom_step,mouse_position)
			elif event.button_index == BUTTON_WHEEL_DOWN:
				zoom_at_point(zoom_step,mouse_position)

func zoom_at_point(zoom_change, mouse_position):
	# Zoom in and out
	var camera_zoom = get_zoom()
	var next_camera_zoom = get_zoom() * zoom_change
	print(camera_zoom, zoom_change, next_camera_zoom)
	
#	if (next_camera_zoom.x <= 1):
#		return
	set_zoom(next_camera_zoom)
	
	# Also center camera at mouse
	var cam_position = get_global_position()
	var viewport_size = get_viewport().size

	var next_cam_position = cam_position + (			# Position camera so that mouse is
			(-0.5 * viewport_size + mouse_position) *	# in the same position relative to the
			(camera_zoom - next_camera_zoom)			# camera as before
		)
	set_global_position(next_cam_position)
	pass
