extends Node

signal trash_spawned()
signal trash_collected()
signal trash_dropped()
signal trash_decayed()
signal microplastics_pollution_changed()
signal anemome_entered()
signal anemone_exited()
signal protection_gained()
signal protection_lost()


func _ready() -> void:
	trash_collected.get_name()
	trash_dropped.get_name()

# TODO: Add information about collected/dropped trash
