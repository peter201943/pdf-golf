# tool # FIXME (add tool mode)
extends KinematicBody


# FIXME (documentation missing)
"""
CLIENT player

Is this    the PLAYER-Character (client)
or is this the SERVER-Character (puppet)
"""


# What the player looks with
var camera: Camera
var pivot: Spatial

# How the player moves around
puppet var puppet_transform
puppet var puppet_motion = Vector3()
var motion = Vector3()

# Adjust how the player moves around
export var speed:int = 100                  # how quickly a player can move
export var acceleration:int = 5             # how quickly a player approaches max speed
export var gravity:float = 0.98             # how fast a player falls
export var jump_power:int = 30              # how high a player can jump
export var mouse_sensitivity:float = 0.003  # how quickly to turn the mouse

# FIXME (documentation missing)
var last_motion: Vector3
var last_transform: Transform

# FIXME (documentation missing)
var knight
var last_anim = 'idle' # FIXME (what is this and why is it only in client?)

# On-Screen Menus
var players_menu: ColorRect # shows the current players
var players_list: ItemList  # the actual list of players
var pause_menu: ColorRect   # allows players to exit during game
var display_name: Label     # floating name-tag above player


func _ready():
	"""
	Capture mouse, reset variables, resync with puppet
	"""
	
	print("CLIENT.player._ready() = loading")
	
	# Bind the References
	players_menu = $HUD/Players # FIXME (fragile link; make external)
	players_list = $HUD/Players/List # FIXME (fragile link; make external)
	pause_menu = $HUD/Panel # FIXME (fragile link; make external)
	camera = $Pivot/Camera # FIXME (fragile link; make external)
	pivot = $Pivot # FIXME (fragile link; make external)
	display_name = $Name/Viewport/GUI/Player # FIXME (fragile link; make external)
	knight = $knight # FIXME (fragile link; make external)
	
	# Hide all the Menus
	pause_menu.hide() # FIXME (non external variable for fragile link!)
	players_menu.hide() # FIXME (non external variable for fragile link!)
	
	# Network Setup
	if is_network_master():
		camera.current = true
		print("I AM NOT A PUPPET!")
	else:
		print("I am a puppet...")
	
	# Reset global variables
	puppet_transform = transform
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	print("CLIENT.player._ready() = done")


func _unhandled_input(event):
	"""
	Mouselook, Mousepress, and Escape User Input
	"""
	
	# Let
	var mouse_motion = event is InputEventMouseMotion
	var mouse_captured = Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	
	# Mouse Left
	if event.is_action_pressed("shoot"):
		if !mouse_captured:
			pause_menu.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if mouse_captured:
			print("BANG!")
	
	# Escape
	if event.is_action_pressed("ui_cancel"):
		if mouse_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_menu.show()
	
	# Mouselook
	if mouse_motion and mouse_captured:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		pivot.rotation.x = clamp(pivot.rotation.x, -0.8, 0.4)


func _physics_process(delta):
	# FIXME REFACTOR (overly long method; too many responsibilities)
	# FIXME (differs from `Server/Source/Player.gd`)
	"""briefly describe why this is here""" # FIXME (documentation missing)
	
	# Reset the Forward/Backward and Left/Right motion
	motion.x = 0
	motion.z = 0

	# Refresh the camera and direction
	var camera_basis = camera.global_transform.basis
	var direction = Vector3()
	
	# If this is a HUMAN
	if is_network_master():
		
		# get the Intended Direction
		if Input.is_action_pressed("move_forward"):
			direction -= camera_basis.z
			if direction.y != 0: print("uh oh") # (why is this here?)
		if Input.is_action_pressed("move_back"):
			direction += camera_basis.z
			if direction.y != 0: print("uh oh") # (why is this here?)
		if Input.is_action_pressed("strafe_left"):
			direction -= camera_basis.x
		if Input.is_action_pressed("strafe_right"):
			direction += camera_basis.x
		
		# Reset the `y`. Somehow moving around messes this up.
		direction.y = 0
		
		# Prevent going faster diagonally
		direction = direction.normalized()
		
		# Apply speed and acceleration
		motion = motion.linear_interpolate(direction * speed, acceleration * delta)
		
		# Apply falling
		motion.y -= gravity
		
		# Add the vertical component if the player jumps
		if Input.is_action_just_pressed("jump") and is_on_floor():
			motion.y = jump_power
		
		# Set the animation state and play
		var anim = 'idle'
		if motion.x != 0 or motion.z != 0:
			anim = "walk"
		play_anim(anim)
		
		# Animation ???
		if last_anim != anim:  # FIXME (what is this and why is it only in client?)
			rpc('play_anim', anim)
		last_anim = anim  # FIXME (what is this and why is it only in client?)
		
		# Motion ???
		if last_motion != motion:
			rset("puppet_motion", motion)
		
		# Transform ???
		if last_transform != transform:
			rset("puppet_transform", transform)
		
		# ???
		last_motion = motion
		last_transform = transform
		
	# If this is a PUPPET
	else:
		# get the server's copy of our transform
		transform = puppet_transform
		motion = puppet_motion
		
	# Move the Player
	motion = move_and_slide(motion, Vector3.UP, true)
	
	# ???
	if not is_network_master():
		print(
			"self.transform: " + str(transform) + 
			"\npuppet.transform: " + str(puppet_transform)
		)
		puppet_transform = transform


func _on_cancel_button_pressed():
	"""when user wants to resume playing game"""
	pause_menu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_quit_button_pressed():
	"""when user wants to stop playing game"""
	get_tree().set_network_peer(null)
	network.end_game() # FIXME (this function only exists in CLIENT player)


func update_list():
	"""Updates the list of actively playing users"""
	players_list.clear()
	# FIXME (why is this not in SERVER?)
	for player in network.players:
		players_list.add_item(network.players[player])


func _process(_delta):
	"""
	2020-09-13: Just handles input
	"""
	handle_input()


func handle_input():
	"""
	FIXED (keyboard) inputs
	- scoreboard
	"""
	
	if Input.is_action_just_pressed("tab"):
		update_list()
		players_menu.show()
		
	if Input.is_action_just_released("tab"):
		players_menu.hide()


puppet func play_anim(anim):
	"""
	Allow SELF or OTHERS to tell my MODEL to animate
	"""
	knight.play_anim(anim)

