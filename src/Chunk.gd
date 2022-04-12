extends Area2D

signal on_crack(chunk, point)


var points:Array = []

onready var collision:CollisionPolygon2D = $CollisionPolygon2D
onready var line:Line2D = $Line2D
onready var polygon:Polygon2D = $Polygon2D


func set_shape(_points):
	points = _points
#	collision.polygon = 
	line.points = points
	polygon.polygon = points


func set_color(color):
	line.default_color = color
	polygon.color = color


func _on_Chunk_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("on_crack", self, event.position)


func _on_Chunk_area_entered(area):
	print('hi')
