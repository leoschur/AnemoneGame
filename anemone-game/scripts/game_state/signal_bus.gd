extends Node

signal trash_collected()
signal trash_dropped()


func _ready() -> void:
	trash_collected.get_name()
	trash_dropped.get_name()

# TODO: Add information about collected/dropped trash
