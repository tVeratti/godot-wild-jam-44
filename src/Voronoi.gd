extends Object

class_name Voronoi

var width:int = 500
var height:int = 500

var rng:RandomNumberGenerator = RandomNumberGenerator.new()

var points:Array = []
var sites:Array = []


func generate(num_points:int = 5, loops:int = 0):
	rng.randomize()
	generate_points(num_points)
	
	sites = get_delauney_polygons(points)
	
	var new_sites = []
	for loop_index in range(loops):
		for index in sites.size():
			var site = sites[index]
			var inner_delauney = get_inner_delauney(site)
			
			new_sites += inner_delauney
			
		sites = new_sites


func generate_points(amount:int):
	points = []
	
	for i in range(amount):
		points.append(Vector2(
			rng.randi_range(0, width),
			rng.randi_range(0, height)))


func get_inner_delauney(triangle, new_point = null):
	
	if new_point == null:
		new_point = Vector2.ZERO
		for point in triangle:
			new_point += point
		
		new_point /= 3
		
	var inner_delauney = get_delauney_polygons(triangle + [new_point])
	return inner_delauney
	


func get_delauney_polygons(inner_points):
	var all_polygons = []
	
	var delauney = Geometry.triangulate_delaunay_2d(inner_points)
	
	# The triangulated delauney points are indeces grouped by 3,
	# so loop through to get each triangle and then discover its
	# center point, which will become one voronoi tesselation.
	var inner_index = 0
	var inner_polygon = []
	
	for index in delauney:
		inner_polygon.append(inner_points[index])
		
		if inner_index == 2:
			all_polygons.append(inner_polygon)
			
			inner_index = -1
			inner_polygon = []
			
		inner_index += 1
	
	return all_polygons


func hypot(x, y):
	return sqrt(pow(x - 1, 2) + pow(y - 1, 2))

func add_site_points():
	pass

