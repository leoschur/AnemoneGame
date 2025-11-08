extends CharacterBody2D

@export var speed = 300
var mouse_position = Vector2(0, 0)

var trash_collected_scn = preload("res://scenes/trash/trash_collected.tscn")
var current_trash: Node2D = null

func _ready() -> void:
	GameStateManager.trash_dropped.connect(drop_all_trash)


func _physics_process(_delta):
	perform_movement()


func perform_movement():
	# Get the mouse position
	#if Input.is_action_pressed("click"):
	mouse_position = get_global_mouse_position()

	# Calculate the direction vector
	var direction = (mouse_position - global_position).normalized()

	# Set the velocity
	if direction: # Only move if there's a direction to move in
		velocity = direction * speed
	else:
		velocity = Vector2(0, 0) # Stop if the player is already at the mouse position

	# Move the player
	move_and_slide()

	# Rotate the player to face the mouse
	# This will point the player's forward direction towards the mouse
	look_at(mouse_position)


func collect_trash():
	print("TRASH COLLECTED")
	if current_trash == null:
		var trash = trash_collected_scn.instantiate()
		$TrashPositon.add_child(trash)
		current_trash = trash


func drop_all_trash():
	if current_trash != null:
		current_trash.queue_free()
