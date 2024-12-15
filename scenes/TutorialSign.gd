extends Node2D

## Exports
export(String, MULTILINE) var text : String

## Functions
func _ready():
	# Set the label's text as the exported text variable
	$PanelContainer/MarginContainer/Label.text = text
	# Set the panel container root as not visible
	$PanelContainer.visible = false
	
	$CollisionArea.connect("area_entered", self, "on_area_entered")
	$CollisionArea.connect("area_exited", self, "on_area_exited")
	
func on_area_entered(_area2d):
	$PanelContainer.visible = true
	$SignSprite.frame = 1
	
func on_area_exited(_area2d):
	$PanelContainer.visible = false
	$SignSprite.frame = 0
