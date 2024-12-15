extends Node2D

## Signals
signal player_won

## Functions
func _ready():
	$Area2D.connect("area_entered", self, "on_area_entered")

func on_area_entered(_area2d):
	emit_signal("player_won") 
	$Confetti.emitting = true

