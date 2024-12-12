extends CanvasLayer

## Functions
func _ready():
	# On loading of this script, connect the UI Button's 
	# pressed function to this script and the on_next_button_pressed function.
	$PanelContainer/MarginContainer/VBoxContainer/Button.connect("pressed", self, "on_next_button_pressed")

func on_next_button_pressed():
	# When the button is pressed, increment the level.
	$"/root/LevelManager".increment_level()
