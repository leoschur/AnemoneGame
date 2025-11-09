@tool
class_name Fish
extends StaticBody2D


const LINK = preload("uid://bbhu0e3rkslb7")

@export_category("Components")
@export var link_container: Node2D
@export var collision_polygon_2d: CollisionPolygon2D
@export var polygon_2d: Polygon2D
@export var line_2d: Line2D

@export_category("Editor Functions")
@export_tool_button("Add Link") var add_link_action = _add_link
@export_tool_button("Redraw") var redraw_action = redraw
@export_tool_button("Clear Links") var clear_links_action = _clear_links

@export_category("Parameters")
@export_range(0.0, 100.0, 1.0) var link_distance: float = 20.0:
	set(value):
		link_distance = value
		if not link_container:
			return
		var i: int = 0
		for link: Link in link_container.get_children():
			link.position = Vector2(link_distance * i, 0.0)
			i += 1
		redraw()
@export_range(0.0, 2.0, 0.05) var roundness_factor: float = 1.0:
	set(value):
		roundness_factor = value
		redraw()
@export var camera: Node2D

@export_category("Movement Parameters")
@export var speed: float = 600.0
@export var max_turn_deg_per_sec: float = 180.0

# Variables
var remote_transform_2d: RemoteTransform2D

# Movement variables
var target_position: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.RIGHT * speed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Generation
	link_container.child_order_changed.connect(_on_child_order_changed)
	for link: Link in link_container.get_children():
		link.update.connect(redraw)
	
	# Add RemoteTransform2D node to head
	if camera:
		var head: Link = link_container.get_children().back()
		remote_transform_2d = RemoteTransform2D.new()
		remote_transform_2d.remote_path = camera.get_path()
		head.add_child(remote_transform_2d)
		remote_transform_2d.owner = head


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var head: Link = link_container.get_children().back()
	# Smooth steering with limited angular speed
	var to_target = target_position - head.global_position
	if to_target.length_squared() < 0.0001:
		head.global_position += velocity * delta
		return
	
	var desired_angle = to_target.angle()
	var current_angle = velocity.angle()
	var angle_diff = wrapf(desired_angle - current_angle, -PI, PI)
	var max_turn = deg_to_rad(max_turn_deg_per_sec) * delta
	var clamped_turn = clamp(angle_diff, -max_turn, max_turn)
	var new_angle = current_angle + clamped_turn
	
	velocity = Vector2.RIGHT.rotated(new_angle) * speed
	head.look_at(head.global_position + velocity)
	head.global_position += velocity * delta
	
	var body: Array[Node] = link_container.get_children()
	body.reverse()
	body = body.slice(1)
	for link: Link in body:
		if link.global_position.distance_to(link.next.global_position) > link_distance:
			var reversed_direction = link.global_position - link.next.global_position
			var new_pos = link.next.global_position + reversed_direction.normalized() * link_distance
			link.global_position = new_pos
	
	redraw()


func _add_link():
	var new_link: Link = LINK.instantiate()
	new_link.update.connect(redraw)
	link_container.add_child(new_link)
	new_link.owner = self


func _clear_links():
	line_2d.points.clear()
	for child in link_container.get_children():
		child.free()


func redraw():
	if not link_container:
		return
	if link_container.get_children().is_empty():
		return
	for child: Link in link_container.get_children():
		child.draw()
	var curve: Curve2D = _create_curve()
	_visualize_curve(curve)


func _on_child_order_changed():
	_update_links()
	redraw()


func _update_links() -> void:
	if link_container.get_children().is_empty():
		return
	# Update link names and distances
	var links: Array[Node] = link_container.get_children()
	var i = 0
	for link: Link in links:
		link.name = "Link" + str(i)
		link.global_position = Vector2(link_distance * i, 0.0)
		i += 1
	# Update link connections
	var links_reversed: Array[Node] = link_container.get_children()
	links_reversed.reverse()
	var next_link: Link = null
	for link: Link in links_reversed:
		link.next = next_link
		next_link = link


func _create_curve() -> Curve2D:
	var curve: Curve2D = Curve2D.new()
	var last_point = Vector2.ZERO
	var tail: Link = link_container.get_children().front()
	var body: Array[Node] = link_container.get_children().slice(1, -1)
	var head: Link = link_container.get_children().back()
	# Tail
	var tail_points = tail.get_shape_points()
	for t_p in tail_points:
		last_point = _add_bezier_point_to_curve(curve, tail, t_p)
	# Body (direction ->)
	for link: Link in body:
		last_point = _add_bezier_point_to_curve(curve, link, link.get_shape_points().back())
	# Head
	var head_points = head.get_shape_points()
	while not head_points.is_empty():
		var closest_point = head_points.front()
		for h_p in head_points:
			if last_point.distance_to(h_p) < last_point.distance_to(closest_point):
				closest_point = h_p
		last_point = _add_bezier_point_to_curve(curve, head, closest_point)
		head_points.remove_at(head_points.find(closest_point))
	# Body (direction <-)
	body.reverse()
	for link: Link in body:
		last_point = _add_bezier_point_to_curve(curve, link, link.get_shape_points().front())
	
	return curve


func _visualize_curve(curve: Curve2D):
	if not line_2d:
		return
	# Smooth the curve with more points
	var smooth_points: Array[Vector2]
	var resolution = 256  # higher -> smoother
	var length = curve.get_baked_length()
	for i in range(resolution + 1):
		smooth_points.append(curve.sample_baked(float(i) / resolution * length) * global_transform)
	collision_polygon_2d.polygon = smooth_points
	polygon_2d.polygon = smooth_points
	line_2d.points = smooth_points


func _add_bezier_point_to_curve(curve: Curve2D, link: Link, point: Vector2) -> Vector2:
	var origin_to_point: Vector2 = (point - link.global_position).normalized()
	var in_point: Vector2 = origin_to_point.rotated(-PI / 2) * (link.radius * roundness_factor)
	var out_point: Vector2 = origin_to_point.rotated(PI / 2) * (link.radius * roundness_factor)
	curve.add_point(point, in_point, out_point)
	return point
