extends CanvasLayer

## Functions
func _ready():
	# On loading of this script, connect the UI Buttons'
	# pressed function to this script and the on_next_pressed function.
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/NextLevelButton.connect("pressed", self, "on_next_pressed")
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/RestartButton.connect("pressed", self, "on_restart_pressed")
	
func on_next_pressed():
	# When the button is pressed, increment the level.
	$"/root/LevelManager".increment_level()
	
func on_restart_pressed():
	$"/root/LevelManager".restart_level()
