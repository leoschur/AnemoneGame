class_name Player
extends Node2D


@export_category("Components")
@export var fish: Fish
@export var trash_stacl: Node2D

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


func _on_collect_trash():
	print("TRASH COLLECTED")
	amount_of_trash_collected += 1
	#if not current_trash:
		#var trash = trash_collected_scn.instantiate()
		#$TrashPosition.add_child(trash)
		#current_trash = trash


func _on_trash_dropped():
	print('dropped ' + str(amount_of_trash_collected) + ' trash')
	amount_of_trash_collected = 0
	#if current_trash != null:
		#current_trash.queue_free()
