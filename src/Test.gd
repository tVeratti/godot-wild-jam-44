extends Node2D

var Chunk = preload("res://Chunk.tscn")


var voronoi
var colors:Array = []

onready var polygons:Node2D = $Polygons


func _ready():
	voronoi = Voronoi.new()
	voronoi.generate(10, 0)
	
	var inner_points = []
	var inner_index = 0
	var color = Color.aqua
	
	for index in voronoi.delaunay.size():
		var site = voronoi.delaunay[index]
		colors.append(random_color())
		
		var chunk = Chunk.instance()
		polygons.add_child(chunk)
		chunk.set_shape(site)
		chunk.set_color(colors[index])
#		chunk.connect("on_crack", self, "_on_chunk_crack")
	
	render_dots(voronoi.points)
	render_dots(voronoi.circumcenters)
#	for site in voronoi.sites:
#		var chunk = Chunk.instance()
#		polygons.add_child(chunk)
#		chunk.set_shape(site)
#		chunk.set_color(random_color())


func render_dots(arr):
	for index in arr.size():
		var center = arr[index]
		var color = colors[index]
		var dot = ColorRect.new()
		dot.color = color
		dot.rect_size = Vector2(8, 8)
		dot.rect_position = center
		polygons.add_child(dot)


func _on_chunk_crack(chunk, point):
	var top_chunk = voronoi.get_inner_delauney(chunk.points, point)
#	var new_chunks = []
#	for inner_chunk in top_chunk:
#		new_chunks += voronoi.get_inner_delauney(inner_chunk)
	
	for shape in top_chunk:
		var new_chunk = Chunk.instance()
		polygons.add_child(new_chunk)
		new_chunk.set_shape(shape)
		new_chunk.connect("on_crack", self, "_on_chunk_crack")
	
	chunk.queue_free()



func random_color() -> Color:
	randomize()

	return Color.from_hsv(
		rand_range(0, 1),
		rand_range(0, 1),
		rand_range(0, 1),
		1.0)
