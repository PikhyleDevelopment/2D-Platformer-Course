extends Node

## Exports
export(PackedScene) var levelCompleteScene : PackedScene

## Signals
signal coin_total_changed

## Global Variables
var playerScene : Resource = preload("res://scenes/Player.tscn")
var pauseScene : Resource = preload("res://scenes/UI/PauseMenu.tscn")
var spawnPosition : Vector2 = Vector2.ZERO
var currentPlayerNode : Node = null
var totalCoins : int = 0
var collectedCoins : int = 0

## Functions
func _ready():
	# Get the spawn position from the player's global position.
	# Then register the player.
	spawnPosition = $PlayerRoot/Player.global_position
	register_player($PlayerRoot/Player)
	
	# Set the initial coin count and ready the flag win condition.
	coin_total_changed(get_tree().get_nodes_in_group("coin").size())
	$Flag.connect("player_won", self, "on_player_won")
	
func _unhandled_input(event):
	# Handle the pause action (defined in project settings)
	# Adds a PauseMenu to the scene as a child node
	if (event.is_action_pressed("pause")):
		var pauseInstance : Node = pauseScene.instance()
		add_child(pauseInstance)
	
func coin_collected():
	# Increments the coins collected
	collectedCoins += 1
	emit_signal("coin_total_changed", totalCoins, collectedCoins)
	
func coin_total_changed(newTotal : int):
	# Sets the total number of coins to the newTotal
	totalCoins = newTotal
	emit_signal("coin_total_changed", totalCoins, collectedCoins)
	
func register_player(playerNode : Node):
	# Grabs the player node and register the call to on_player_died
	currentPlayerNode = playerNode
	currentPlayerNode.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)
	
func create_player():
	# Get a new player instance and add the instance below the current player node
	var playerInstance : Node = playerScene.instance()
	$PlayerRoot.add_child(playerInstance)
	# Set the new players spawn position
	playerInstance.global_position = spawnPosition
	# Register the new player with the game.
	register_player(playerInstance)
	
func on_player_died():
	# When the player has died, free the character from memory and create
	# a new player.
	currentPlayerNode.queue_free()
	
	# Create a '1' (one) second timer and then
	# pause (yield) the function for the timer duration.
	# Determines how long until we spawn a new player. 
	# Lets us see more of the death animation as well.
	var timer : SceneTreeTimer = get_tree().create_timer(1.5)
	yield(timer, "timeout")
	
	create_player()

func on_player_won():
	# When the player has won, free the character from memory
	currentPlayerNode.queue_free()
	# Instance a new levelComplete Scene
	var levelComplete : Node = levelCompleteScene.instance()
	# Add the levelComplete scene as a child to the current scene root node.
	add_child(levelComplete)
