extends Node2D

var Chunk = preload("res://Chunk.tscn")
var Crack = preload("res://Crack.tscn")


var colors:Array = []

onready var polygons:Node2D = $Polygons
onready var cracks:Node2D = $Cracks


func _ready():
	var chunks = ChunkGenerator.new()
	chunks.generate(20)
	
	for triangle in chunks.delaunay:
		var chunk = Chunk.instance()
		polygons.add_child(chunk)
		chunk.set_shape(triangle)
	
	
	var crack = Crack.instance()
	crack.connect("on_click", self, "_on_crack")
	cracks.add_child(crack)


func _on_crack(crack, point):
	for chunk in polygons.get_children():
		print(chunk.get_overlapping_areas())


func random_color() -> Color:
	randomize()

	return Color.from_hsv(
		rand_range(0, 1),
		rand_range(0, 1),
		rand_range(0, 1),
		1.0)
