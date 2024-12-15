extends Node

## Global Variables
var screenTransitionScene : Resource = preload("res://scenes/UI/ScreenTransition.tscn")

## Functions
func transition_to_scene(scenePath : String):
	var screenTransition : Node = screenTransitionScene.instance()
	add_child(screenTransition)
	yield(screenTransition, "screen_covered")
	get_tree().change_scene(scenePath)

func transition_to_menu():
	transition_to_scene("res://scenes/UI/MainMenu.tscn")
