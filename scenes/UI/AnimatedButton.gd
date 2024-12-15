extends Button

## Exports
export(bool) var disableHoverAnimation

## Functions
func _ready():
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	connect("focus_exited", self, "on_focus_exited")
	connect("pressed", self, "on_pressed")
	
func _process(_delta):
	rect_pivot_offset = rect_min_size / 2
	
func reset_button_state():
	if (!disableHoverAnimation):
		$HoverAnimationPlayer.play_backwards("hover")
	
func on_mouse_entered():
	if (!disableHoverAnimation):
		$HoverAnimationPlayer.play("hover")
		
func on_focus_exited():
	reset_button_state()
	
func on_mouse_exited():
	reset_button_state()

func on_pressed():
	$AudioStreamPlayer.play()
	$ClickAnimationPlayer.play("click")
