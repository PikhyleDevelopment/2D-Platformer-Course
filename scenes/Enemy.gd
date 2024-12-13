extends KinematicBody2D

## Global Variables
var maxSpeed : int = 25
var velocity : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO 
var gravity : int = 500
var startDirection : Vector2 = Vector2.RIGHT

## Functions
func _ready():
	direction = startDirection
	$GoalDetector.connect("area_entered", self, "on_goal_entered")
	$HitboxArea.connect("area_entered", self, "on_hitbox_entered")
	
func on_hitbox_entered(_area2d):
	$"/root/Helpers".apply_camera_shake(1)
	queue_free()

func _process(delta):
	velocity.x = (direction * maxSpeed).x
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	$AnimatedSprite.flip_h = true if direction.x > 0 else false
	
func on_goal_entered(_area2d):
	direction *= -1
