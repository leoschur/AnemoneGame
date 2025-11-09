class_name Player
extends Node2D


@export_category("Components")
@export var fish: Fish
@export var trash_stack: Node2D

@export_category("Parameters")
@export var trash_stack_distance: float = 200.0

# Variables
var amount_of_trash_collected: int = 0

# Visibility in anemones
var is_hidden = false


func _ready() -> void:
	SignalBus.trash_collected.connect(_on_collect_trash)
	SignalBus.trash_dropped.connect(_on_trash_dropped)


func _physics_process(_delta: float) -> void:
	var desired_pos: Vector2 = get_global_mouse_position()
	fish.target_position = desired_pos
	
	# Update trash stack position
	var tail: Link = fish.get_links().back()
	var tail_to_trash: Vector2 = trash_stack.global_position - tail.global_position
	var new_position = tail.global_position + tail_to_trash.normalized() * trash_stack_distance
	trash_stack.global_position = new_position


func _on_collect_trash(trash: Trash):
	var new_trash_sprite: Sprite2D = Sprite2D.new()
	trash_stack.add_child(new_trash_sprite)
	new_trash_sprite.owner = self
	new_trash_sprite.texture = trash.sprite_2d.texture
	new_trash_sprite.global_transform = trash.sprite_2d.global_transform
	# Hide old sprite
	trash.sprite_2d.hide()
	# Tween new sprite
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(new_trash_sprite, "position", Vector2.ONE * 100.0 * randf(), 1.0)
	tween.tween_property(new_trash_sprite, "rotation", randf_range(-PI / 2, PI / 2), 1.0).as_relative()
	tween.tween_property(new_trash_sprite, "scale", Vector2.ONE * randf_range(0.9, 1.1), 1.0)
	
	amount_of_trash_collected += 1


func _on_trash_dropped():
	pass
	#print('dropped ' + str(amount_of_trash_collected) + ' trash')
	#amount_of_trash_collected = 0
	#if current_trash != null:
		#current_trash.queue_free()
