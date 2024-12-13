extends Camera2D

## Exports
# Adds the backgroundColor variable to the inspector
export(Color, RGB) var backgroundColor : Color
export(OpenSimplexNoise) var shakeNoise : OpenSimplexNoise

## Global Variables
var targetPosition : Vector2 = Vector2.ZERO
var xNoiseSampleVector : Vector2 = Vector2.RIGHT
var yNoiseSampleVector : Vector2 = Vector2.DOWN
var xNoiseSamplePosition : Vector2 = Vector2.ZERO
var yNoiseSamplePosition : Vector2 = Vector2.ZERO
var noiseSampleTravelRate : int = 500
var maxShakeOffset : int = 10
var currentShakePercentage : int = 0
var shakeDecayPercentage : int = 2

## Functions
func _ready():
	# Set the background color in game.
	VisualServer.set_default_clear_color(backgroundColor)

func _process(delta):
	acquire_target_position()
	
	# Used for smooth movement of the camera with the player.
	# lerp is similar to player movement lerp
	global_position = lerp(targetPosition, global_position, pow(2, -15 * delta))
	
	if (currentShakePercentage > 0):
		# If the current shake percentage is greater than 0, add to the 
		# x and y noise sample position by the respective vector and 
		# noise sample travel rate. Don't forget to include delta
		xNoiseSamplePosition += xNoiseSampleVector * noiseSampleTravelRate * delta
		yNoiseSamplePosition += yNoiseSampleVector * noiseSampleTravelRate * delta
		var xSample : float = shakeNoise.get_noise_2d(xNoiseSamplePosition.x, xNoiseSamplePosition.y)
		var ySample : float = shakeNoise.get_noise_2d(yNoiseSamplePosition.x, yNoiseSamplePosition.y)
		
		# Calculate offset as a product of a Vector2 of xSample and ySample,
		# maxShakeOffset, and currentShakePercentage.
		var calculatedOffset : Vector2 = Vector2(xSample, ySample) * maxShakeOffset * pow(currentShakePercentage, 2)
		# Set the camera's offset to our calculatedOffset
		offset = calculatedOffset
# warning-ignore:narrowing_conversion
		currentShakePercentage = clamp(currentShakePercentage - shakeDecayPercentage * delta, 0, 1)

func acquire_target_position():
	# Get the "player" from the scene tree.
	var acquired : bool = target_postition_from_group("player")
	if (!acquired):
		target_postition_from_group("player_death")

func target_postition_from_group(groupName : String):
	var nodes : Array = get_tree().get_nodes_in_group(groupName)
	if (nodes.size() > 0):
		# We have at least one node
		var node : Node = nodes[0]
		targetPosition = node.global_position
		return true
	return false

func apply_shake(percentage : float):
	# Clamp the value between zero and one
# warning-ignore:narrowing_conversion
	currentShakePercentage = clamp(currentShakePercentage + percentage, 0, 1)
	
