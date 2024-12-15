extends CanvasLayer

## Global Variables
onready var continueButton : Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton
onready var optionsButton : Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
onready var quitButton : Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

var optionsMenuScene : Resource = preload("res://scenes/UI/OptionsMenu.tscn")

## Functions
func _ready():
	# Add button connections
	continueButton.connect("pressed", self, "on_continue_pressed")
	optionsButton.connect("pressed", self, "on_options_pressed")
	quitButton.connect("pressed", self, "on_quit_pressed")
	
	# Pause the scene tree from the root
	get_tree().paused = true
	
func _unhandled_input(event):
	# If the pause action (defined in project settings)
	# is pressed, we unpause because we are already paused.
	if (event.is_action_pressed("pause")):
		unpause()
		# Takes the event and stops propogation up the scene tree.
		get_tree().set_input_as_handled()
	
func unpause():
	# Free the resource and unpause the scene tree.
	queue_free()
	get_tree().paused = false
	
func on_continue_pressed():
	# When we press the continue button, we unpause
	unpause()
	
func on_options_pressed():
	var optionsMenuInstance : Node = optionsMenuScene.instance()
	add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	$MarginContainer.visible = false
	
func on_options_back_pressed():
	$MarginContainer.visible = true
	$OptionsMenu.queue_free()
	
func on_quit_pressed():
	# When we quit to menu, we just transition to that scene and 
	# unpause the game.
	$"/root/ScreenTransitionManager".transition_to_menu()
	unpause()
