# tool # FIXME (add tool mode)
extends KinematicBody


"""
CLIENT player

This script serves as both a PUPPET and a PLAYER
- A *PUPPET* is a *robot*, it receives instructions over the Internet from a REAL player
- A *PLAYER* emits instructions over the Internet that *PUPPETS* receive

This script handles
- networking (remote calls)
- mouse input (look, fire)
- keyboard input (menus)
- physics (falling, motion)
- menus (pause, main)
- hud's (nametag)
"""


# What the player looks with
var camera: Camera
var pivot: Spatial

# How the player indicates how to move around
var camera_basis: Basis
var direction: Vector3

# How PUPPETS move around
puppet var puppet_transform
puppet var puppet_motion = Vector3()

# How PLAYERS move around
var motion: Vector3
var anim: String

# Adjust how the player moves around
export var speed:int = 100                  # how quickly a player can move
export var acceleration:int = 5             # how quickly a player approaches max speed
export var gravity:float = 0.98             # how fast a player falls
export var jump_power:int = 30              # how high a player can jump
export var mouse_sensitivity:float = 0.003  # how quickly to turn the mouse

# Record Change Across Frames
# (these are needed by the server to know)
# (when a player moves in a new direction)
var last_anim: String           # If we change animation
var last_motion: Vector3        # If we change direction
var last_transform: Transform   # If we change position

# What is displayed and animated
var knight

# On-Screen Menus
var players_menu: ColorRect # shows the current players
var players_list: ItemList  # the actual list of players
var pause_menu: ColorRect   # allows players to exit during game
var display_name: Label     # floating name-tag above player

# Debugging
var is_puppet: bool


func _ready():
	"""
	Capture mouse, reset variables, resync with puppet
	"""
	
	print("SERVER.player._ready() = loading")
	
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
		is_puppet = false
	else:
		print("I am a puppet...")
		is_puppet = true
	
	# Reset global variables
	puppet_transform = transform
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	motion = Vector3()
	
	print("SERVER.player._ready() = done")


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
	"""
	Updates variables, moves the player, gets player input,
	handles that input, applies effects, changes, and updates
	"""
	refresh_physics_variables()
	if not is_puppet:
		apply_human_direction(delta)
		apply_effects()
		apply_updates()
		apply_history()
	if is_puppet:
		apply_puppet_direction()
	apply_motion()


func refresh_physics_variables():
	"""
	Every physics cycle, update anything for physics
	"""
	
	# Reset the Forward/Backward and Left/Right motion
	motion.x = 0
	motion.z = 0

	# Refresh the camera and direction
	camera_basis = camera.global_transform.basis
	direction = Vector3()
	

func apply_human_direction(delta):
	"""Let a human set the input"""
	
	# get the Intended Direction
	if Input.is_action_pressed("move_forward"):
		direction -= camera_basis.z
	if Input.is_action_pressed("move_back"):
		direction += camera_basis.z
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


func apply_effects():
	"""
	Every physics frame, any animations
	"""
	
	# Set the animation state and play
	anim = 'idle'
	if motion.x + motion.z != 0:
		anim = "walk"
	play_anim(anim)
	

func apply_updates():
	"""
	Every phyics frame, anything ther server might need to know
	"""
	
	# When we have stopped moving, update the server
	if last_anim != anim:
		rpc('play_anim', anim)
	
	# Motion ???
	if last_motion != motion:
		rpc('play_anim', anim)
		rset("puppet_motion", motion)
	
	# Transform ???
	if last_transform != transform:
		rset("puppet_transform", transform)


func apply_history():
	"""Update last ___ for next cycle"""
	last_anim = anim
	last_motion = motion
	last_transform = transform


func apply_puppet_direction():
	"""
	If we are a puppet, we need the server's
	instance of our transform and motion
	"""
	transform = puppet_transform
	motion = puppet_motion
	

func apply_motion():
	"""
	Every cycle, move the player and update the puppet
	"""
	# Move the Player
	motion = move_and_slide(motion, Vector3.UP, true)
	# update the puppet after the puppet has moved around
	if is_puppet:
		puppet_transform = transform


func _on_cancel_button_pressed():
	"""when user wants to resume playing game"""
	pause_menu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_quit_button_pressed():
	"""when user wants to stop playing game"""
	get_tree().set_network_peer(null)
	if not is_puppet:
		pass # FIXME (see `CLIENT/Player.gd#_on_quit_button_pressed()`)


func update_list():
	"""Updates the list of actively playing users"""
	if not is_puppet:
		players_list.clear()
		# FIXME (see `CLIENT/Player.gd#update_list()`)


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

