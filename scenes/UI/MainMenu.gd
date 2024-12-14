extends CanvasLayer

## Global Variables

onready var playButton : Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PlayButton
onready var optionsButton : Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionsButton
onready var quitButton : Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready():
	playButton.connect("pressed", self, "on_play_pressed")
	quitButton.connect("pressed", self, "on_quit_pressed")
	
func on_play_pressed():
	$"/root/LevelManager".change_level(0)
	
func on_quit_pressed():
	get_tree().quit()
