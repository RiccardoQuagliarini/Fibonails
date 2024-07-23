class_name Room extends Node2D

@onready var Room_Scene = preload("res://scenes/Room.tscn")
@onready var Snail_Scene = preload("res://scenes/Shell.tscn")

var firstWallA : Vector2
var firstWallB : Vector2
var lastWallA : Vector2
var lastWallB : Vector2
var roomName
var points : PackedVector2Array
var ShellInstance : Shell
var color
	
func _ready():	
	pass
	
func _process(_delta):
	pass

func _draw():
	# draw all points in points
	#for point in points:
	#	draw_circle(point, 2, color)
		
	draw_polygon(points, [color])
	draw_circle(lastWallA, 1, Color.YELLOW)
	draw_line(lastWallA, lastWallB, Color.GREEN_YELLOW, 2)
	draw_circle(lastWallB, 1, Color.BLUE)
	
	draw_circle(firstWallB, 1, Color.RED)
	draw_line(firstWallA, firstWallB, Color.NAVY_BLUE, 2)
	draw_circle(firstWallA, 1, Color.REBECCA_PURPLE)

	pass

		
func init_room(parent_shell: Shell, room_name: String, c: Color, first_wall_a: Vector2 = Vector2.ZERO, first_wall_b: Vector2 = Vector2.ZERO) -> void:
	# find the first straight wall
	# get last room from hell_mantel_edge.rooms	
	ShellInstance = parent_shell
	
	roomName = room_name
	color = c

	lastWallA = ShellInstance.mantel.edge
	lastWallB = ShellInstance.closestIntersection
	
	firstWallB = first_wall_b
	firstWallA = first_wall_a
	
	
	# print("lastWallA: ", lastWallA)
	# print("lastWallB: ", lastWallB)
	# print("firstWallB: ", firstWallB)
	# print("firstWallA: ", firstWallA)
	
	# consider ShellInstance.mantel is a Line2D in the shape of a spiral.
	# find the area within the spiral and the straight walls
	
	#points.append_array([firstWallA, firstWallB, lastWallB, lastWallA])
	#points.append_array(ShellInstance.mantel.points)

	

	calculate_enclosed_surface([lastWallA, lastWallB, firstWallB, firstWallA], ShellInstance.mantel.points)

	queue_redraw()

func calculate_enclosed_surface(corners : Array, line : PackedVector2Array):
	# Extract the corner points A, B, C, and D
	var A = corners[0]
	var B = corners[1]
	var C = corners[2]
	var D = corners[3]
	var A_index = line.find(A)
	var B_index = line.find(B)
	var C_index = line.find(C)
	var D_index = line.find(D)
	
	print("corners: ", A, ", ", B, ", ", C, ", ", D, ".")
	print("indexes: ", A_index, ", ", B_index, ", ", C_index, ", ", D_index, ".")
	print("range BC:", range(B_index, C_index, -1).size())
	print("range DA:", range(D_index, A_index).size())
	# Add the straight line segment from A to B
	points.append(A)
	points.append(B)

	# Find the indices of B and C in the spiral line
	
	# Add the spiral segment from B to C
	for i in range(B_index, C_index, -1):
		points.append(line[i])

	# Add the straight line segment from C to D
	points.append(C)
	points.append(D)

	# Find the indices of D and A in the spiral line

	# Add the spiral segment from D to A (handle wrap around if necessary)
	if D_index < A_index:
		for i in range(D_index, A_index):
			points.append(line[i])
	else:
		for i in range(D_index, line.size()):
			points.append(line[i])
		for i in range(0, A_index + 1):
			points.append(line[i])
