extends Node

signal trash_collected()
signal trash_dropped()
signal anemome_entered()
signal anemone_exited()


func _ready() -> void:
	trash_collected.get_name()
	trash_dropped.get_name()

# TODO: Add information about collected/dropped trash
