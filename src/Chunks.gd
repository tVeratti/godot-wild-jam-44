extends Object

class_name ChunkGenerator


var width:int = 200
var height:int = 200
var site_size:int = 80
var site_variation:int = 50

var rng:RandomNumberGenerator = RandomNumberGenerator.new()

var points:Array = []
var delaunay:Array = []
var circumcenters:Array = []
var sites:Array = []


func generate(num_points:int = 5, loops:int = 0):
	rng.randomize()
	
	points = generate_points(num_points)
	delaunay = get_delauney_polygons(points)
	circumcenters = get_circumcenters(delaunay)
	sites = []
	
#	for point in points:
#		# Loop through the points used to create delauney triangles
#		# Get all triangles that touch this point; this means they are adjacent
#		var adjacent_circumcenters = []
#		for index in delaunay.size():
#			var triangle = delaunay[index]
#			for triangle_point in triangle:
#				if triangle_point == point and not adjacent_circumcenters.has(index):
#					adjacent_circumcenters.append(circumcenters[index])
#
##		adjacent_circumcenters.sort_custom(self, "sort_circumcenters")
#		sites.append(adjacent_circumcenters)
		


func generate_points(amount:int):
	var vectors = []
	
	var row_size = amount / 2
	for x in range(row_size):
		for y in range(row_size):
			var new_point = Vector2(
				x * (site_size + rng.randi_range(-site_variation, site_variation)),
				y * (site_size + rng.randi_range(-site_variation, site_variation)))
		
			vectors.append(new_point)
		
	return vectors


func get_circumcenters(delaunay_triangles):
	var centers = []
	for triangle in delaunay_triangles:
		var circumcenter = get_circumcenter(triangle[0], triangle[1], triangle[2])
		centers.append(circumcenter)
	
	return centers


func sort_circumcenters(a, b):
	var angle_a = atan2(a.x, a.y)
	var angle_b = atan2(b.x, b.y)
	
	return angle_a > angle_b


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


func get_circumcenter(a:Vector2, b:Vector2, c:Vector2):
	var x1 = a.x
	var y1 = a.y
	
	var x2 = b.x
	var y2 = b.y
	
	var x3 = c.x
	var y3 = c.y
	
	var a2 = x1 - x2;
	var a3 = x1 - x3;
	var b2 = y1 - y2;
	var b3 = y1 - y3;
	var d1 = x1 * x1 + y1 * y1;
	var d2 = d1 - x2 * x2 - y2 * y2;
	var d3 = d1 - x3 * x3 - y3 * y3;
	var ab = (a3 * b2 - a2 * b3) * 2;
	var xa = (b2 * d3 - b3 * d2) / max(ab - x1, 1);
	var ya = (a3 * d2 - a2 * d3) / max(ab - y1, 1);
	
	return Vector2(x1 + xa, y1 + ya)


func hypot(x, y):
	return sqrt(pow(x - 1, 2) + pow(y - 1, 2))


