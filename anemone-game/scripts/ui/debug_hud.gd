extends Control

func _ready() -> void:
	SignalBus.trash_spawned.connect(_on_trash_spawned)
	SignalBus.trash_collected.connect(_on_trash_collected)
	SignalBus.trash_dropped.connect(_on_trash_dropped)
	SignalBus.microplastics_pollution_changed.connect(_on_microplastics_pollution_changed)
	SignalBus.protection_gained.connect(_on_protection_gained)
	SignalBus.protection_lost.connect(_on_protection_lost)
	
	_on_trash_spawned()
	_on_trash_collected(null)
	_on_protection_lost()
	_on_microplastics_pollution_changed()


func _on_trash_spawned():
	$VBoxContainer/TrashOnMapLabel.text = "Trash on Map: " + str(GameStateManager.trash_on_map)
	
	
func _on_trash_collected(_trash: Trash):
	$VBoxContainer/TrashCollectedLabel.text = "Trash carried: " + str(GameStateManager.trash_carried)
	
	
func _on_trash_dropped():
	$VBoxContainer/TrashOnMapLabel.text = "Trash on Map: " + str(GameStateManager.trash_on_map)
	$VBoxContainer/TrashCollectedLabel.text = "Trash carried: " + str(GameStateManager.trash_carried)


func _on_microplastics_pollution_changed():
	$VBoxContainer/MicroplasticsPollutionLabel.text = "Microplastics Pollution: " + str(float(GameStateManager.current_micro_plastic_pollution) / float(GameStateManager.max_micro_plastic_pollution) * 100.0) + "%" 


func _on_protection_gained():
	$VBoxContainer/SafeFromSharkLabel.text = "Protected"


func _on_protection_lost():
	$VBoxContainer/SafeFromSharkLabel.text = "Not Protected"
