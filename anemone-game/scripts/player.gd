extends CharacterBody2D

class_name Player

@export var acceleration: float = 4000
@export var minSpeed: float = 150
@export var maxSpeed: float = 300
@export var rotation_speed := 2.0
var mouse_position = Vector2(0, 0)

var trash_collected_scn = preload("res://scenes/trash/trash_collected.tscn")
var current_trash: Node2D = null
var amount_of_trash_collected := 0


func _ready() -> void:
	SignalBus.trash_collected.connect(collect_trash)
	SignalBus.trash_dropped.connect(drop_all_trash)


func _physics_process(_delta):
	perform_movement(_delta)


func perform_movement(delta):
	mouse_position = get_global_mouse_position()
	#print(mouse_position)
	var target = (mouse_position - global_position).normalized()
	
	if global_position.distance_to(mouse_position) > 1:

		velocity += target * acceleration * delta
		var speed = velocity.length()
		speed = clamp(speed, minSpeed, maxSpeed)
		velocity = velocity.normalized() * speed
	
	# Move the player
	move_and_slide()
	
	var desired_angle = target.angle()
	var angle_diff = wrapf(desired_angle - rotation, -PI, PI)
	var max_step = rotation_speed * delta
	rotation += clamp(angle_diff, -max_step, max_step)
	look_at(mouse_position)


func collect_trash():
	print("TRASH COLLECTED")
	amount_of_trash_collected = amount_of_trash_collected + 1
	if current_trash == null:
		var trash = trash_collected_scn.instantiate()
		$TrashPosition.add_child(trash)
		current_trash = trash


func drop_all_trash():
	print('dropped ' + str(amount_of_trash_collected) + ' trash')
	amount_of_trash_collected = 0
	if current_trash != null:
		current_trash.queue_free()
