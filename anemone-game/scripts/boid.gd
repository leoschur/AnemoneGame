extends Node2D

class_name Boid

@export var maxVelocity: float = 280
@export var maxAcceleration: float = 1000
@export var rotationOffset: float = PI/2.

var velocity := Vector2.ZERO
var acceleration := Vector2.ZERO

var neighbors := []
var neighborsDistances := []
var timeOutOfBorders := 0.0

func _ready():
	velocity = Vector2(randf_range(-maxVelocity, maxVelocity),
						randf_range(-maxVelocity, maxVelocity))

func _process(delta):
	velocity += acceleration.limit_length(maxAcceleration * delta)
	velocity = velocity.limit_length(maxVelocity)
	acceleration.x = 0
	acceleration.y = 0
	
	position += velocity * delta
	
	look_at(position + velocity)
	rotation += rotationOffset
