extends Camera2D

var targetPosition = Vector2.ZERO

# Adds the backgroundColor variable to the inspector
export(Color, RGB) var backgroundColor

func _ready():
	# Set the background color in game.
	VisualServer.set_default_clear_color(backgroundColor)

func _process(delta):
	acquire_target_position()
	
	# Used for smooth movement of the camera with the player.
	# lerp is similar to player movement lerp
	global_position = lerp(targetPosition, global_position, pow(2, -15 * delta))
		
func acquire_target_position():
	# Get the "player" ground fro the scene tree.
	var players = get_tree().get_nodes_in_group("player")
	if (players.size() > 0):
		# we have at least one player
		var player = players[0]
		targetPosition = player.global_position

