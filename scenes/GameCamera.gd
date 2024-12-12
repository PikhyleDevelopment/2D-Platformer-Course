extends Camera2D

## Exports
# Adds the backgroundColor variable to the inspector
export(Color, RGB) var backgroundColor
export(OpenSimplexNoise) var shakeNoise

## Global Variables
var targetPosition = Vector2.ZERO
var xNoiseSampleVector = Vector2.RIGHT
var yNoiseSampleVector = Vector2.DOWN
var xNoiseSamplePosition = Vector2.ZERO
var yNoiseSamplePosition = Vector2.ZERO
var noiseSampleTravelRate = 500
var maxShakeOffset = 10
var currentShakePercentage = 0
var shakeDecayPercentage = 2

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
		xNoiseSamplePosition += xNoiseSampleVector * noiseSampleTravelRate * delta
		yNoiseSamplePosition += yNoiseSampleVector * noiseSampleTravelRate * delta
		var xSample = shakeNoise.get_noise_2d(xNoiseSamplePosition.x, xNoiseSamplePosition.y)
		var ySample = shakeNoise.get_noise_2d(yNoiseSamplePosition.x, yNoiseSamplePosition.y)
		
		var calculatedOffset = Vector2(xSample, ySample) * maxShakeOffset * pow(currentShakePercentage, 2)
		# Set the camera's offset to our calculatedOffset
		offset = calculatedOffset
		currentShakePercentage = clamp(currentShakePercentage - shakeDecayPercentage * delta, 0, 1)

func acquire_target_position():
	# Get the "player" ground fro the scene tree.
	var players = get_tree().get_nodes_in_group("player")
	if (players.size() > 0):
		# we have at least one player
		var player = players[0]
		targetPosition = player.global_position

func apply_shake(percentage):
	# Clamp the value between zero and one
	currentShakePercentage = clamp(currentShakePercentage + percentage, 0, 1)
	
