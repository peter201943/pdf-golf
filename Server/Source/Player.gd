# tool # FIXME (add tool mode)
extends KinematicBody


# FIXME (documentation missing)
"""
SERVER player

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
export var speed:int = 100
export var acceleration:int = 5
export var gravity:float = 0.98
export var jump_power:int = 30
export var mouse_sensitivity:float = 0.003

# FIXME (documentation missing)
var last_motion: Vector3
var last_transform: Transform

# FIXME (documentation missing)
var knight
# FIXME (why is `idle` missing?)

# On-Screen Menus
var players_menu: ColorRect
var players_list: ItemList
var pause_menu: ColorRect
var display_name: Label

# Debugging
var unsaid = true # tell if we are a puppet or not


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
	
	# ???
	if is_network_master():
		camera.current = true
	
	# Reset global variables
	puppet_transform = transform
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
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
	# FIXME REFACTOR (overly long method; too many responsibilities)
	# FIXME (differs from `Client/Source/Player.gd`)
	"""briefly describe why this is here""" # FIXME (documentation missing)
	
	# Reset the Forward/Backward and Left/Right motion
	motion.x = 0
	motion.z = 0
	
	# Refresh the camera and direction
	var camera_basis = camera.global_transform.basis
	var direction = Vector3()
	
	# If this is not an instance of a PUPPET
	if is_network_master():
		
		# DELETEME (Debug only, temp)
		if unsaid:
			print("I AM NOT A PUPPET!")
			unsaid = false
		
		direction.y = 0
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
		direction.y = 0
		
		direction = direction.normalized()
		
		motion = motion.linear_interpolate(direction * speed, acceleration * delta)
		motion.y -= gravity
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			motion.y = jump_power
		
		var anim = "idle"
		if motion.x != 0 or motion.z != 0:
			anim = "walk"
		
		play_anim(anim)
		if last_motion != motion:
			rpc('play_anim', anim)
			rset("puppet_motion", motion)
		if last_transform != transform:
			rset("puppet_transform", transform)
		
		last_motion = motion
		last_transform = transform
		
	else:

		# DELETEME (Debug only, temp)
		if unsaid:
			print("...I am a puppet...")
			unsaid = false

		transform = puppet_transform
		motion = puppet_motion
		
	motion = move_and_slide(motion, Vector3.UP, true)
	if not is_network_master():
		puppet_transform = transform


func _on_cancel_button_pressed():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	pause_menu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_quit_button_pressed():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	get_tree().set_network_peer(null)
	#network.end_game() # FIXME (this function only exists in CLIENT player)


func update_list():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	players_list.clear() # FIXME (non external variable for fragile link!)
	#for player in network.players:
	#	$HUD/Players/List.add_item(network.players[player])


func _process(_delta):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	handle_input()


func handle_input():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	
	if Input.is_action_just_pressed("tab"):
		update_list()
		players_menu.show() # FIXME (non external variable for fragile link!)
	
	if Input.is_action_just_released("tab"):
		players_menu.hide() # FIXME (non external variable for fragile link!)


puppet func play_anim(anim):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	knight.play_anim(anim)

