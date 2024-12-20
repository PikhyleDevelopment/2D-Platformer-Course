extends KinematicBody2D

## Enums
enum State {NORMAL, DASHING, INPUT_DISABLED}

## Signals
signal died

## Exports
export(int, LAYERS_2D_PHYSICS) var dashHazardMask : int

## Variables
var playerDeathScene : Resource = preload("res://scenes/PlayerDeath.tscn")
var footstepParticles : Resource = preload("res://scenes/FootstepParticles.tscn")
var velocity : Vector2 = Vector2.ZERO
var gravity : int = 1000
var maxHorizontalSpeed : int = 140
var maxDashSpeed : int = 500
var minDashSpeed : int = 100
var horizontalStopSpeed : int = -50
var horizontalAcceleration : int = 2000
var jumpSpeed : int = 360
var jumpTerminationMultiplier : int = 4
var defaultHazardMask : int = 0
var hasDash : bool = false
var isStateNew : bool = true
var hasDoubleJump : bool = false
var isDying : bool = false
var currentState : int = State.NORMAL

## Functions
# Called when the node enters the scene tree for the first time.
func _ready():
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	$AnimatedSprite.connect("frame_changed", self, "on_animated_sprite_frame_change")
	defaultHazardMask = $HazardArea.collision_mask

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
		State.INPUT_DISABLED:
			process_input_disabled(delta)
	isStateNew = false

func change_state(newState : int):
	currentState = newState
	isStateNew = true	

func process_dash(delta):
	if (isStateNew):
		$DashAudioPlayer.play()
		# Enable dash particles
		$DashParticles.emitting = true
		# Apply camera shake
		$"/root/Helpers".apply_camera_shake(0.5)
		# Enable the dash collision area
		$DashArea/DashCollision.disabled = false
		# Play the jump animation
		$AnimatedSprite.play("jump")
		# Apply the mask
		$HazardArea.collision_mask = dashHazardMask
		
		var moveVector = get_movement_vector()
		var velocityMod = 1
		if (moveVector.x != 0):
			velocityMod = sign(moveVector.x)
		else:
			velocityMod = 1 if $AnimatedSprite.flip_h else -1
			
		velocity = Vector2(maxDashSpeed * velocityMod, 0)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))
	
	if (abs(velocity.x) < minDashSpeed):
		call_deferred("change_state", State.NORMAL)
		
func process_input_disabled(delta):
	if (isStateNew):
		$AnimatedSprite.play("idle")
	velocity.x = lerp(0, velocity.x, pow(2, horizontalStopSpeed * delta))
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	

func process_normal(delta):
	if (isStateNew):
		# Disable particle emission
		$DashParticles.emitting = false
		# Disable the dash collision area
		$DashArea/DashCollision.disabled = true
		# Apply the default hazard mask
		$HazardArea.collision_mask = defaultHazardMask
		
	var moveVector : Vector2 = get_movement_vector()
	
	# Assign x velocity with acceleration
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if (moveVector.x == 0):
		# If moveVector.x is 0 (no input), slow the player
		# until stopped. Change horizontalStopSpeed to tweak.
		velocity.x = lerp(0, velocity.x, pow(2, horizontalStopSpeed * delta))
		
	# Clamp so we can't move faster than maxHorizontalSpeed
	# in either direction.
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	# if the y axis of moveVector is less than 0,
	# assign velocity Y axis.
	if (moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump)):
		velocity.y = moveVector.y * jumpSpeed
		# Apply camera shake using AutoLoad
		$"/root/Helpers".apply_camera_shake(0.5)
		
		if (!is_on_floor() && $CoyoteTimer.is_stopped()):
			$"/root/Helpers".apply_camera_shake(0.6)
			hasDoubleJump = false
			
		$CoyoteTimer.stop()
		
	# If we just press the jump action, increase gravity temporarily
	# to shorten the jump height. Else, apply a regular, larger
	# jump.
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:	
		# Apply gravity to the velocity Y axis.
		velocity.y += gravity * delta
		
		
	var wasOnFloor : bool = is_on_floor()
	
	# Use the KinematicBody2D.move_and_slide method
	# to udpate velocity.
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# If we were on the floor and are not not on the floor
	if (wasOnFloor && !is_on_floor()):
		# Start the coyote timer.
		# NOTE: Coyote time allows us to jump JUST after
		# leaving the floor, like walking off the edge of a block.
		$CoyoteTimer.start()
	
	if (!wasOnFloor && is_on_floor() && !isStateNew):
		spawn_footstep_particles(1.5)
	
	if (is_on_floor()):
		hasDoubleJump = true
		hasDash = true
	
	if (hasDash && Input.is_action_just_pressed("dash")):
		call_deferred("change_state", State.DASHING)
		hasDash = false
	
	update_animation()

func get_movement_vector():
		# Movement (refactor later)
		var moveVector : Vector2 = Vector2.ZERO
		
		# Will be 1 if moving right, -1 if moving left. If both inputs
		# are active at the same time, they cancel each other out.
		moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		
		# A fancy way to conditionally set a variable.
		moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
		return moveVector

func update_animation():
	var moveVector : Vector2 = get_movement_vector()
	
	# NOTE: is_on_floor is part of KinematicBody2D
	if (!is_on_floor()):
		# Use the $ sign to access nodes in scene tree
		# or use get_node("NodeName")
		
		# If the sprite is not on the floor,
		# play the jump animation
		$AnimatedSprite.play("jump")
	elif (moveVector.x != 0):
		# If movement speed on x access is not 0
		# and we aren't on the floor, play the run animation
		$AnimatedSprite.play("run")
	else:
		# we aren't doing anything, be idle.
		$AnimatedSprite.play("idle")
	
	# If we are moving, update the flip_h switch.
	if (moveVector.x != 0):
		# Set the flip_h switch to true if we are moving right.
		$AnimatedSprite.flip_h = true if moveVector.x > 0 else false

func kill():
	# Check to see if we are dying already.
	# This helps prevent a crash if we hit two 
	# spike hitboxes at the same time.
	if (isDying):
		return
		
	# If we made it here, we are dying.
	isDying = true
	# Instance the player death scene
	var playerDeathInstance : Node = playerDeathScene.instance()
	# Also preserve the player's velocity. YEET
	playerDeathInstance.velocity = velocity
	# Add the player death instance as a child node of the player node.
	get_parent().add_child_below_node(self, playerDeathInstance)
	# Set the global_position of the player death to the player's global position
	playerDeathInstance.global_position = global_position
	
	# Emit the "died" signal.
	emit_signal("died")
	
func spawn_footstep_particles(scale = 1):
	# Create an instance of the FootstepParticles
	var footstep : Node = footstepParticles.instance()
	# Add the footstep particles as a child node
	get_parent().add_child(footstep)
	# Set the scale of the particles.
	footstep.scale = Vector2.ONE * scale
	# Set the footstep particles global position equal to
	# the player's global position.
	footstep.global_position = global_position
	# Play the footstep audio
	$FootstepAudioPlayer.play()
	
func disable_player_input():
	change_state(State.INPUT_DISABLED)

func on_hazard_area_entered(_area2d):
	# Apply camera shake to the death
	$"/root/Helpers".apply_camera_shake(1)
	call_deferred("kill")
	
func on_animated_sprite_frame_change():
	# If we are in the run animation and on frame 0 (when the feet touch the
	# ground), play our footstep particles.
	if ($AnimatedSprite.animation == "run" && $AnimatedSprite.frame == 0):
		spawn_footstep_particles()
			
	
