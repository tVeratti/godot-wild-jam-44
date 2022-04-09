extends Area2D

signal on_crack(chunk, point)


var points:Array = []

onready var collision:CollisionPolygon2D = $CollisionPolygon2D
onready var line:Line2D = $Line2D


func set_shape(_points):
	points = _points
	collision.polygon = points
	line.points = points


func _on_Chunk_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print(event.position)
		emit_signal("on_crack", self, event.position)
