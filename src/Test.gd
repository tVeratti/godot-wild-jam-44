extends Node2D

var Chunk = preload("res://Chunk.tscn")


var voronoi

onready var polygons:Node2D = $Polygons


func _ready():
	voronoi = Voronoi.new()
	voronoi.generate(10, 0)
	
	var inner_points = []
	var inner_index = 0
	var color = Color.aqua
	
	for site in voronoi.sites:
		var chunk = Chunk.instance()
		polygons.add_child(chunk)
		chunk.set_shape(site)
		chunk.connect("on_crack", self, "_on_chunk_crack")
		
#		var line = Line2D.new()
#		line.points = site
#		line.default_color = Color(1, 1, 1, 0.2)
#		line.width = 1.0
#		line.antialiased = true
#		polygons.add_child(line)


func _on_chunk_crack(chunk, point):
	var new_inner = voronoi.get_inner_delauney(chunk.points, point)
	for inner_chunk in new_inner:
		var new_chunk = Chunk.instance()
		polygons.add_child(new_chunk)
		new_chunk.set_shape(inner_chunk)
		new_chunk.connect("on_crack", self, "_on_chunk_crack")
	
	chunk.queue_free()
	

func random_color() -> Color:
	randomize()

	return Color.from_hsv(
		rand_range(0, 1),
		rand_range(0, 1),
		rand_range(0, 1),
		1.0)
