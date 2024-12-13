extends Node

## Exports
export(Array, PackedScene) var levelScenes

## Global Variables
var currentLevelIndex : int = 0	

## Functions
func change_level(levelIndex : int):
	# Set our current index to the provided index
	currentLevelIndex = levelIndex
	
	if (currentLevelIndex >= levelScenes.size()):
		# If our index is the size of levelScenes or larger,
		# we are out of bounds and need to reset to 0
		currentLevelIndex = 0
	# Call the scene trees change_scene method, setting the parameter
	# to the full path of the level to change to as defined in the exported
	# variable levelScenes
	get_tree().change_scene(levelScenes[currentLevelIndex].resource_path)

func increment_level():
	# Increment the current level index.
	change_level(currentLevelIndex + 1)
