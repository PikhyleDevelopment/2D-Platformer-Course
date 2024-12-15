extends CanvasLayer

## Signals
signal back_pressed

## Global Variables
onready var backButton : Node = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton
onready var winModeButton : Node = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WinModeButton
onready var musicRangeControl : Node = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MusicVolumeContainer/RangeControl
onready var sfxRangeControl : Node = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SFXVolumeContainer/RangeControl

var fullscreen : bool = false


## Functions
func _ready():
	winModeButton.connect("pressed", self, "on_win_mode_button_pressed")
	backButton.connect("pressed", self, "on_back_button_pressed")
	musicRangeControl.connect("percentage_changed", self, "on_music_volume_changed")
	sfxRangeControl.connect("percentage_changed", self, "on_sfx_volume_changed")
	update_display()
	update_initial_volume_settings()

func update_display():
	winModeButton.text = "WINDOWED" if !fullscreen else "FULLSCREEN"
	
func update_bus_volume(busName : String, volumePercent : float):
	var busIndex : int = AudioServer.get_bus_index(busName)
	var volumeDB : float = linear2db(volumePercent)
	AudioServer.set_bus_volume_db(busIndex, volumeDB)
	
func get_bus_volume_percent(busName : String):
	var busIndex : int = AudioServer.get_bus_index(busName)
	var volumePercent : float = db2linear(AudioServer.get_bus_volume_db(busIndex))
	return volumePercent
	
func update_initial_volume_settings():
	var musicPercent = get_bus_volume_percent("Music")
	var sfxPercent = get_bus_volume_percent("SFX")
	musicRangeControl.set_current_percentage(musicPercent)
	sfxRangeControl.set_current_percentage(sfxPercent)

func on_win_mode_button_pressed():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen 
	update_display()
	
func on_back_button_pressed():
	emit_signal("back_pressed")
	
func on_music_volume_changed(percent : float):
	update_bus_volume("Music", percent)

func on_sfx_volume_changed(percent : float):
	update_bus_volume("SFX", percent)
