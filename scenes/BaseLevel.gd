extends Node

## Exports
export(PackedScene) var levelCompleteScene

## Signals
signal coin_total_changed

## Global Variables
var playerScene = preload("res://scenes/Player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null
var totalCoins = 0
var collectedCoins = 0

## Functions
func _ready():
	# Get the spawn position from the player's global position.
	# Then register the player.
	spawnPosition = $Player.global_position
	register_player($Player)
	
	# Set the initial coin count and ready the flag win condition.
	coin_total_changed(get_tree().get_nodes_in_group("coin").size())
	$Flag.connect("player_won", self, "on_player_won")
	
func coin_collected():
	# Increments the coins collected
	collectedCoins += 1
	emit_signal("coin_total_changed", totalCoins, collectedCoins)
	
func coin_total_changed(newTotal):
	# Sets the total number of coins to the newTotal
	totalCoins = newTotal
	emit_signal("coin_total_changed", totalCoins, collectedCoins)
	
func register_player(playerNode):
	# Grabs the player node and register the call to on_player_died
	currentPlayerNode = playerNode
	currentPlayerNode.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)
	
func create_player():
	# Get a new player instance and add the instance below the current player node
	var playerInstance = playerScene.instance()
	add_child_below_node(currentPlayerNode, playerInstance)
	# Set the new players spawn position
	playerInstance.global_position = spawnPosition
	# Register the new player with the game.
	register_player(playerInstance)
	
func on_player_died():
	# When the player has died, free the character from memory and create
	# a new player.
	currentPlayerNode.queue_free()
	create_player()

func on_player_won():
	# When the player has won, free the character from memory
	currentPlayerNode.queue_free()
	# Instance a new levelComplete Scene
	var levelComplete = levelCompleteScene.instance()
	# Add the levelComplete scene as a child to the current scene root node.
	add_child(levelComplete)
