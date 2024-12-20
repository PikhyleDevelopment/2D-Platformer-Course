extends KinematicBody2D

## Exports
export(bool) var isSpawning : bool = true

## Global Variables
var enemyDeathScene : Resource = preload("res://scenes/EnemyDeath.tscn")
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

func _process(delta):
	if (isSpawning):
		return
	
	velocity.x = (direction * maxSpeed).x
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	$Visuals/AnimatedSprite.flip_h = true if direction.x > 0 else false

func kill():
	var deathInstance : Node = enemyDeathScene.instance()
	get_parent().add_child(deathInstance)
	deathInstance.global_position = global_position
	if (velocity.x > 0):
		deathInstance.scale = Vector2(-1, 1)
	queue_free()
	
func on_goal_entered(_area2d):
	direction *= -1

func on_hitbox_entered(_area2d):
	$"/root/Helpers".apply_camera_shake(1)
	call_deferred("kill")
