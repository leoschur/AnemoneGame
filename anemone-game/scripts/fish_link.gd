@tool
class_name FishLink
extends Node2D


@export_category("Parameters")
@export_range(0.0, 100.0, 1.0) var radius: float = 50.0:
	set(value):
		radius = value
@export_range(0.0, 100.0, 1.0) var number_of_points: float = 10.0:
	set(value):
		number_of_points = value
@export var fill_color: Color:
	set(value):
		fill_color = value
@export var stroke_color: Color:
	set(value):
		stroke_color = value
@export_range(0.0, 100.0, 1.0) var stroke_width: float = 10.0:
	set(value):
		stroke_width = value
@export_tool_button("Redraw") var redraw_button = draw_link

@export_category("Components")
@export var polygon_2d: Polygon2D
@export var line_2d: Line2D

var _points: Array[Vector2] = []
var prev_link: FishLink = null
var next_link: FishLink = null


func _ready():
	draw_link()


func _process(delta):
	var speed = 400.0
	if prev_link:
		var distance_to_prev_link = abs(prev_link.position - self.position).length()
		var dir_to_prev_link = (prev_link.position - self.position).normalized()
		if distance_to_prev_link > 40.0:
			self.position += dir_to_prev_link * speed * delta
	if next_link:
		var distance_to_next_link = abs(next_link.position - self.position).length()
		var dir_to_next_link = (next_link.position - self.position).normalized()
		if distance_to_next_link > 40.0:
			self.position += dir_to_next_link * speed * delta


func draw_link():	
	_points.clear()
	for point_index in range(number_of_points):
		var point_angle = (2 * PI / number_of_points) * point_index
		var point_x = radius * cos(point_angle)
		var point_y = radius * sin(point_angle)
		var point_pos = Vector2(point_x, point_y)
		_points.append(point_pos)
	polygon_2d.polygon = _points
	polygon_2d.color = fill_color
	line_2d.points = _points
	line_2d.default_color = stroke_color
	line_2d.width = stroke_width
