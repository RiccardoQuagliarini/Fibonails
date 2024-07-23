@tool
extends RayCast2D
# Called when the node enters the scene tree for the first time.
var collisionPoint : Vector2
@onready var mantel = $".."

var safeDistance = 20

func _ready():
	pass
	
func _draw():
	# position is yellow
	draw_circle(Vector2.ZERO, 2.0, Color.BLUE)
	if (collisionPoint):
		draw_circle(collisionPoint, 2.0, Color.YELLOW)
		
func _process(_delta):
	position = mantel.edge
	global_translate(Vector2(-20, 0))
	target_position = to_local(mantel.position)
	queue_redraw()
	
func _physics_process(_delta):
	if is_colliding():
		#print("is colliding")
		collisionPoint = get_collision_point()
		print(collisionPoint)
		queue_redraw()
