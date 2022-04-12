extends Node

signal on_click(crack, position)


const VARIATION:float = 1.5
const LENGTH:float = 5.0
const MINIMUM_DIRECTION:float = 0.3


onready var line:Line2D = $Line2D
onready var point_nodes:Node2D = $Points


var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var points:Array = [Vector2.ZERO]
var primary_direction:Vector2 = Vector2.ZERO
var previous_direction:Vector2 = Vector2.ZERO


func _ready():
	next()
	primary_direction = previous_direction
	
	update_shapes()


func next():
	rng.randomize()
	
	var new_direction:Vector2 = primary_direction
	
	while abs(new_direction.direction_to(primary_direction).length()) < MINIMUM_DIRECTION:
		new_direction += Vector2(
			rng.randf_range(-VARIATION, VARIATION),
			rng.randf_range(-VARIATION, VARIATION))
	
	previous_direction = new_direction.normalized()
	points.append(points.back() + (new_direction * LENGTH))
	
	return new_direction


func update_shapes():
	for child in point_nodes.get_children():
		child.queue_free()
		
	for point in points:
		var collision_dot:CollisionShape2D = CollisionShape2D.new()
		var shape =  CircleShape2D.new()
		shape.radius = 2.0
		collision_dot.shape  = shape
		collision_dot.position = point
		point_nodes.add_child(collision_dot)
	
	line.points = points


func _on_Crack_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		next()
		update_shapes()
		emit_signal("on_click", self, event.position)


func _on_Crack_area_entered(area):
	print(area.name)
