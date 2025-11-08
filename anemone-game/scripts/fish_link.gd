@tool
class_name FishLink
extends Node2D


@export_category("Parameters")
@export_range(0.0, 100.0, 1.0) var radius: float = 50.0:
	set(value):
		radius = value

# Link data
var link_dir: Vector2 = Vector2.ZERO
var left_point: Vector2 = Vector2.ZERO
var right_point: Vector2 = Vector2.ZERO

# Head data
var is_head: bool = false
var head_points = []

# Tail data
var is_tail: bool = false
var tail_points = []

# Body data
var prev: FishLink = null
var next: FishLink = null


# Updates link if not head
func _process(delta):
	
	#if Engine.is_editor_hint():
		#return
	
	if not is_head and next:
		var new_pos = self.position
		var new_dir = (next.position - self.position).normalized()
		var next_distance = abs(next.position - self.position).length()
		
		#if prev and next:
			#var spine_1: Vector2 = (self.global_position - next.global_position).normalized()
			#var spine_2: Vector2 = (prev.global_position - self.global_position).normalized()
			#var angle_between_spines: float = spine_1.angle_to(spine_2)
			#var abs_angle = rad_to_deg(abs(angle_between_spines))
			#if abs_angle > 30.0:
				#new_dir = new_dir.rotated(deg_to_rad(30.0))
		
		if next_distance > 20.0:
			new_pos += new_dir * 400.0 * delta
		update_link(new_pos, new_dir)


# Updates link position, direction and side points
func update_link(pos: Vector2, dir: Vector2):
	global_position = pos
	link_dir = dir
	left_point = pos + dir.rotated(PI/2.0) * radius
	right_point = pos + dir.rotated(-PI/2.0) * radius


func update_head(pos: Vector2, dir: Vector2):
	global_position = pos
	link_dir = dir
	left_point = pos + dir.rotated(PI/2.0) * radius
	right_point = pos + dir.rotated(-PI/2.0) * radius
	
	head_points.clear()
	for i in range(4):
		head_points.append(pos + dir.rotated(((PI/2.0) / 5.0) * (4-i)) * radius)
	head_points.append(pos + dir * radius)
	for i in range(4):
		head_points.append(pos + dir.rotated(((-PI/2.0) / 5.0) * (i+1)) * radius)


func update_tail():
	var pos = global_position
	var dir = -link_dir
	tail_points.clear()
	for i in range(4):
		tail_points.append(pos + dir.rotated(((PI/2.0) / 5.0) * (4-i)) * radius)
	tail_points.append(pos + dir * radius)
	for i in range(4):
		tail_points.append(pos + dir.rotated(((-PI/2.0) / 5.0) * (i+1)) * radius)
