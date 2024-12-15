extends Node

## Exports
export(int) var numberToPlay : int = 2
export(bool) var enablePitchRandomization : bool = true
export(float) var minPitchScale : float = 0.9
export(float) var maxPitchScale : float = 1.1

## Global Variables
var rng = RandomNumberGenerator.new()

## Functions
func _ready():
	# We need to call this on ready otherwise we get the
	# same random sequence of numbers. Kind of a weird gotcha
	rng.randomize()

func play():
	var validNodes : Array = []
	for streamPlayer in get_children():
		# If the streamPlayer is not currently playing,
		# add it to the array.
		if (!streamPlayer.playing):
			validNodes.append(streamPlayer)
			
	for i in numberToPlay:
		# If we don't have any validNodes,
		# break out of the loop to prevent crashing.
		if (validNodes.size() == 0):
			break
		# Set a random index number so we can play a sound randomly.
		var index : int = rng.randi_range(0, validNodes.size() - 1)
		
		if (enablePitchRandomization):
			validNodes[index].pitch_scale = rng.randf_range(minPitchScale, maxPitchScale)
		
		# Play that sound at the given index.
		validNodes[index].play()
		# Remove the streamPlayer from the array at the given index.
		validNodes.remove(index)
