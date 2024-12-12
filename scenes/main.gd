extends Node

## Functions
func _ready():
	# When loaded, change the level to index 0
	$"/root/LevelManager".change_level(0)
