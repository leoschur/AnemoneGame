extends Node2D

const SHARK = preload("uid://badvssrgels4l")

 # FIXME adjust based on Scene Borders
@export var map_size: Vector2 = Vector2(2500, 1000)

@export var shark: Shark
@export var player: Player
@export var outside_path: Path2D

@export var peace_timer: Timer
@export var hunt_timer: Timer

var _await_despawn: bool = false

func _ready() -> void:
	peace_timer.start()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_shark_attack"):
		if shark and not _await_despawn:
			hunt_timer.stop()
			_on_hunt_timer_timeout()
		else:
			peace_timer.stop()
			_on_peace_timer_timeout()


func _on_peace_timer_timeout() -> void:
	print("Shark Attack incoming")
	# TODO SOUNDEFFEKT sharkattack
	
	# shark spawnen random on outside_path
	var spawn_point = get_rand_point_on_outside_path()
	shark = SHARK.instantiate()
	shark.fish.place(spawn_point) # FIXME <--- check for error
	shark.target = player
	shark.on_the_hunt = true
	shark.map_size = map_size
	self.add_child(shark)
	shark.owner = self
	
	hunt_timer.start()


func _on_hunt_timer_timeout() -> void:
	print("Shark lost interest")
	shark.on_the_hunt = false
	
	var exit_point = get_rand_point_on_outside_path()
	shark.target_point(exit_point)
	# FIXME despawn on reach of final destination instead of timer
	# TIME after which shark actually is despawned!!!
	_await_despawn = true
	get_tree().create_timer(4.0).timeout.connect(shark.queue_free)
		
	peace_timer.start()


func free_shark():
	print("Shark despawned")
	shark.queue_free()
	_await_despawn = false


func get_rand_point_on_outside_path() -> Vector2:
	var total_len = outside_path.curve.get_baked_length()
	var rand_off = randf() * total_len
	return outside_path.curve.sample_baked(rand_off)
