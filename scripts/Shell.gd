class_name Shell extends Node2D

@export var radius: float = 0.0
@export var angle: float = 0.0
@export var radius_factor: float = 1.0  # Initial radius factor
@export var radius_growth_factor: float = 0.1  # Growth rate factor

var angle_radiants: float = 0.0
var angle_degrees: float = 0.0

var is_growing: bool = true

@onready var mantel := $Mantel
@onready var accept_dialog := $AcceptDialog

@onready var Room_Scene := preload("res://scenes/Room.tscn")

var surface_area: float = 0.0
var room_size: float = 2000.0
var rooms: Array = []

var closestIntersection : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	angle = 20.0
	radius_factor = 1.0
	radius_growth_factor = 0.1
	surface_area = 0.0
	radius = radius_factor * exp(radius_growth_factor * angle)	
	mantel.edge = Vector2(radius * cos(angle), radius * sin(angle))
	
	accept_dialog.add_button("Red", false, "Red")
	accept_dialog.add_button("Blue", false, "Blue")
	accept_dialog.add_button("Yellow", false, "Yellow")
	accept_dialog.add_button("White", false, "White")
	accept_dialog.position.y = 200
	
	# Connect the input event to handle user choices
	set_process_input(true)
	# Connect the dialog's confirmed signal

func _draw():	
	#draw_line(Vector2.ZERO, mantel.edge, Color.AQUA, 1)	
	# draw all interesections
	#for intersection in intersections:
	#	draw_circle(intersection, 2.0, Color.YELLOW)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# calculate radiants and degrees
	#angle_radiants = fmod(angle, 2 * PI)
	#angle_degrees = angle_radiants * 180.0 / PI
	
	# if growing, increase the angle
	if is_growing:
		angle += delta * 10
		radius = radius_factor * exp(radius_growth_factor * angle)		
		
		# Calculate the surface area enclosed by the spiral
		surface_area = calculate_logarithmic_spiral_area(radius_factor, radius_growth_factor)
		#print("surface_area: ", surface_area)
		
		if (surface_area > room_size):
			is_growing = false
			var growth_ratio = log(radius_growth_factor * angle)
			room_size = surface_area * growth_ratio
			
			# calculate a line from edge to the origin
			var line = Line2D.new()
			line.points = [position, mantel.edge]

			# calculate the closest intersection point with the mantel
			closestIntersection = calculate_intersections()
			
			show_room_choice_dialog()	
			
		# convert radius and angle to carthesian coordinates
		mantel.edge = Vector2(radius * cos(angle), radius * sin(angle))
		
		rotation = -angle

func calculate_logarithmic_spiral_area(a, b):
	return (a * a / (2 * b)) * (exp(2 * b * angle) - 1)
	
func show_room_choice_dialog():
	# Show a dialog or UI to let the user choose how to use the new room space
	accept_dialog.popup()

func _on_accept_dialog_custom_action(action):
	print("Picked room ", action)
	populate_room(Color.from_string(action,Color(1, 1, 1)))
	accept_dialog.visible = false
	is_growing = true
	
func _on_accept_dialog_confirmed():
	_on_accept_dialog_custom_action("Black")

func populate_room(color = Color(1, 1, 1)):
	# Instance the Room scene
	var room_instance : Room = Room_Scene.instantiate()	
	
	if (rooms == []):
		room_instance.init_room(self, "Core", Color.BLACK, Vector2.ZERO, Vector2.ZERO)
	else:
		# get last room in rooms
		var previous_room = rooms[rooms.size() - 1]
		room_instance.init_room(self, "Room " + str(rooms.size() + 1), color, previous_room.lastWallA, previous_room.lastWallB)

	# Add the room instance to the main scene and the rooms array
	rooms.append(room_instance)
	add_child(room_instance)

func calculate_intersections() -> Vector2:
	# for each segment of the spiral, check if it intersects with the intersecting line
	var intersections = []
	for i in range(mantel.points.size() - 1):
		if (mantel.points[i] == mantel.edge) or (mantel.points[i + 1] == mantel.edge):
			continue
	
		var edge = mantel.edge
		var intersection = Geometry2D.segment_intersects_segment(
			Vector2.ZERO, mantel.edge,
			mantel.points[i], mantel.points[i + 1])
		
		if intersection:
			intersections.append([intersection, i])
	
	var closest_point = [Vector2.ZERO, 0]
	if (mantel.points.size() > 0):
		closest_point = [mantel.points[0], 0]
		var min_distance = 1000000
		for intersection in intersections:
			var distance = intersection[0].distance_to(mantel.edge)
			if distance < min_distance:
				min_distance = distance
				closest_point = intersection
	mantel.add_point(closest_point[0], closest_point[1])
	
	return closest_point[0]
