extends HBoxContainer

## Signals
signal percentage_changed

## Global Variables
var currentPercentage : float = 1.0

## Functions
func _ready():
	$SubtractButton.connect("pressed", self, "on_button_pressed", [-.1])
	$PlusButton.connect("pressed", self, "on_button_pressed", [.1])
	
func set_current_percentage(percent):
	currentPercentage = clamp(percent, 0, 1)
	var labelNumber : float = currentPercentage * 10
	labelNumber = round(labelNumber)
	$Label.text = str(labelNumber)
	emit_signal("percentage_changed", currentPercentage)
	
func on_button_pressed(change):
	set_current_percentage(currentPercentage + change)
	
