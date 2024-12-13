extends KinematicBody2D

## Global Variables
var velocity : Vector2 = Vector2.ZERO
var gravity : int = 1000

## Functions
func _process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if (is_on_floor()):
		# We need to pass Vector2.ZERO as the first argument
		# instead of '0' (zero) because the 2nd argument
		# is of type Vector2. Setting to '0' caused a Vector2 
		# to float conversion error.
		velocity = lerp(Vector2.ZERO, velocity, pow(2, -5 * delta))
