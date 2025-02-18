extends StaticBody2D

func _ready():
	var curve = $Path2D.curve
	var polygon = curve.get_baked_points()
	
	$Polygon2D.polygon = polygon
	$Line2D.points = polygon
	$CollisionPolygon2D.polygon = polygon
