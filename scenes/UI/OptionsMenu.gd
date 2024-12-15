extends CanvasLayer

## Signals
signal back_pressed

## Global Variables
onready var backButton : Node = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton
onready var winModeButton : Node = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WinModeButton

var fullscreen : bool = false


## Functions
func _ready():
	winModeButton.connect("pressed", self, "on_win_mode_button_pressed")
	backButton.connect("pressed", self, "on_back_button_pressed")
	update_display()

func update_display():
	winModeButton.text = "WINDOWED" if !fullscreen else "FULLSCREEN"

func on_win_mode_button_pressed():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen 
	update_display()
	
func on_back_button_pressed():
	emit_signal("back_pressed")
