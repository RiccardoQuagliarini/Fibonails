@tool
class_name Mantel extends Line2D

@export var edge: Vector2

# The role of the Mantel, is to grow
# growing consists in adding points to the Line2D
# and setting its color

func _draw():
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	# set a gradient color
	width = 4
	gradient = Gradient.new()
	gradient.add_point(0, Color(0, 0, 1))
	gradient.add_point(1, Color(1, 0, 0))
	add_point(Vector2.ZERO)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	add_point(edge)

	
