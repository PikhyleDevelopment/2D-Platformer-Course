extends Node2D

func _ready():
	# When an object enters the Area2D space, call the corresponding
	# function at last argument (on_area_entered in this case)
	$Area2D.connect("area_entered", self, "on_area_entered")
	
	
func on_area_entered(_area2d):
	# remove the coin from the game.
	$AnimationPlayer.play("pickup")
	# Safe way to change physics related options.
	# On last frame, call the disable_pickup function.
	call_deferred("disable_pickup")
	
	var baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.coin_collected()
	
func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
	