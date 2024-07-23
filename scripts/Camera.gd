extends Camera2D

# Zoom factor change per input step
var zoom_step := 0.1
# Minimum and maximum zoom limits
var min_zoom := 0.1
var max_zoom := 10.0

func _ready():
	# Connect the input event handler
	set_process_input(true)

func _input(event):
	if Input.is_action_just_pressed("ui_page_up"):
		zoom_in()
	elif Input.is_action_just_pressed("ui_page_down"):
		zoom_out()

func zoom_in():
	var new_zoom = zoom - Vector2(zoom_step, zoom_step)
	if new_zoom.x >= min_zoom and new_zoom.y >= min_zoom:
		zoom = new_zoom

func zoom_out():
	var new_zoom = zoom + Vector2(zoom_step, zoom_step)
	if new_zoom.x <= max_zoom and new_zoom.y <= max_zoom:
		zoom = new_zoom
