@tool
extends Node2D


const FISH_LINK = preload("uid://b8kv0npx7hj7a")

@export_tool_button("Generate fish form") var generate_fish_form_button = generate_fish_form

@export_category("Components")
@export var fish_outline: Line2D

var _link_sizes = []
var _fish_links: Array[FishLink]


func _ready():
	generate_fish_form()


func _process(delta):
	
	draw_outline()
	
	if Engine.is_editor_hint():
		return
	
	var head = get_child(get_children().size() - 1)
	var snd_link = get_child(get_children().size() - 2)
	var trd_link = get_child(get_children().size() - 3)
	var speed = 500.0
	var turn_factor = 0.5
	
	var moving_dir: Vector2 = (head.position - snd_link.position).normalized()
	var moving_dir_1 = moving_dir
	var moving_dir_2: Vector2 = (snd_link.position - trd_link.position).normalized()
	if Input.is_action_pressed("left"):
		moving_dir = (moving_dir.rotated((-PI / 2.0) * turn_factor)).normalized()
	if Input.is_action_pressed("right"):
		moving_dir = (moving_dir.rotated((PI / 2.0) * turn_factor)).normalized()
	var turn_angle = moving_dir_1.angle_to(moving_dir_2)
	var angle_threshold = 0.35
	if abs(turn_angle) > angle_threshold:
		turn_angle = angle_threshold
		moving_dir = moving_dir_1.normalized()
	head.position += moving_dir * speed * delta


func generate_fish_form():
	var new_number_of_fish_links = randi_range(8, 8)
	var new_link_sizes = []
	#new_link_sizes.append(randf_range(20.0, 20.0))
	#new_link_sizes.append(randf_range(25.0, 25.0))
	#new_link_sizes.append(randf_range(20.0, 20.0))
	for link_index in range(new_number_of_fish_links):
		new_link_sizes.append(randf_range(40.0, 40.0))
	_link_sizes = new_link_sizes
	draw_fish()


func draw_fish():
	# reset
	for child in get_children():
		if child.is_in_group("fish_link"):
			child.free()
	var fish_length = 0.0
	_fish_links = []
	
	var i = 1
	for link_length in _link_sizes:
		var new_link: FishLink = FISH_LINK.instantiate()
		if not _fish_links.is_empty():
			var last_link = _fish_links[_fish_links.size() - 1]
			last_link.next_link = new_link
			new_link.prev_link = last_link
		_fish_links.append(new_link)
		new_link.name = str("FishLink", i)
		new_link.add_to_group("fish_link")
		i += 1
		new_link.radius = link_length
		new_link.position = Vector2(fish_length, 0.0)
		fish_length = fish_length + new_link.radius
		self.add_child(new_link)
		new_link.owner = self
		draw_outline()


func draw_outline():
	var outline_points = []
	if (_fish_links.size() - 1) * 2 < 0.0:
		return
	outline_points.resize((_fish_links.size() - 1) * 2)
	outline_points.fill(0.0)
	
	for link_index in range(_fish_links.size() - 1):
		if link_index == _fish_links.size() - 1:
			#for point in _fish_links[link_index + 1]._points:
				#outline_points.insert(link_index, point + _fish_links[link_index + 1].position)
			continue
		var next_link_index = link_index + 1
		var vector_to_next_link = _fish_links[next_link_index].position - _fish_links[link_index].position
		var vector_middle_to_side_left = vector_to_next_link.rotated(PI / 2.0)
		var vector_middle_to_side_right = vector_to_next_link.rotated(-PI / 2.0)
		var vector_to_side_point_left = _fish_links[link_index].position + vector_middle_to_side_left
		var vector_to_side_point_right = _fish_links[link_index].position + vector_middle_to_side_right
		outline_points[link_index] = vector_to_side_point_left
		outline_points[(_fish_links.size() * 2) - 3 - link_index] = vector_to_side_point_right
	
	fish_outline.points = outline_points
