# tool # FIXME (add tool mode)
extends KinematicBody


# FIXME (documentation missing)
"""
Is this    the PLAYER-Character (client)
or is this the SERVER-Character (puppet)
"""


# What the player looks with
onready var camera = $Pivot/Camera # FIXME (fragile link; make external)

# FIXME (documentation missing)
puppet var puppet_transform
puppet var puppet_motion = Vector3()
var motion = Vector3()

# FIXME (documentation missing)
var random_number_generator = RandomNumberGenerator.new()

# FIXME (documentation missing)
export var speed = 100
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
export var mouse_sensitivity = 0.003

# FIXME (documentation missing)
var last_motion
var last_transform

# FIXME (documentation missing)
onready var knight = $knight # FIXME (fragile link; make external)
var last_anim = 'idle'


func _ready():
	"""
	2020-09-13: Hides the connect-menu and player-menu
	Capture mouse, reset variables, resync with puppet
	"""
	
	# Hide the Menus
	print("CLIENT.player._ready() = loading")
	$HUD/Panel.hide() # FIXME (fragile link; make external)
	$HUD/Players.hide() # FIXME (fragile link; make external)
	
	# ???
	if is_network_master():
		camera.current = true
	
	# reset global variables
	puppet_transform = transform
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print("CLIENT.player._ready() = done")


func _unhandled_input(event):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	var mouse_motion = event is InputEventMouseMotion
	var mouse_captured = Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("shoot"):
		if !mouse_captured:
			$HUD/Panel.hide() # FIXME (fragile link; make external)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_cancel"):
		if mouse_captured:
			release_mouse()
			$HUD/Panel.show() # FIXME (fragile link; make external)
	if mouse_motion and mouse_captured:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity) # FIXME (fragile link; make external)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -0.8, 0.4) # FIXME (non external variable for fragile link!)


func _physics_process(delta): # FIXME REFACTOR (overly long method; too many responsibilities)
	"""briefly describe why this is here""" # FIXME (documentation missing)
	motion.x = 0
	motion.z = 0
	
	var camera_basis = camera.global_transform.basis
	var direction = Vector3()
	
	if is_network_master():
		if Input.is_action_pressed("move_forward"):
			direction -= camera_basis.z
			if direction.y != 0:
				direction.y = 0
		if Input.is_action_pressed("move_back"):
			direction += camera_basis.z
			if direction.y != 0:
				direction.y = 0
		if Input.is_action_pressed("strafe_left"):
			direction -= camera_basis.x
		if Input.is_action_pressed("strafe_right"):
			direction += camera_basis.x
		
		direction = direction.normalized()
		
		motion = motion.linear_interpolate(direction * speed, acceleration * delta)
		motion.y -= gravity
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			motion.y = jump_power
		
		var anim = 'idle'
		
		if motion.x != 0 or motion.z != 0:
			anim = "walk"
		else:
			anim = "idle"
		
		play_anim(anim)
		if last_anim != anim:
			rpc('play_anim', anim)
		last_anim = anim
		if last_motion != motion:
			rset("puppet_motion", motion)
		if last_transform != transform:
			rset("puppet_transform", transform)
		
		last_motion = motion
		last_transform = transform
		
	else:
		transform = puppet_transform
		motion = puppet_motion
		
	motion = move_and_slide(motion, Vector3.UP, true)
	if not is_network_master():
		puppet_transform = transform


func set_player_name(player):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	$Name/Viewport/GUI/Player.text = player # FIXME (fragile link; make external)


func _on_cancel_button_pressed():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	$HUD/Panel.hide() # FIXME (fragile link; make external)
	release_mouse()


func capture_mouse():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func release_mouse():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_quit_button_pressed():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	get_tree().set_network_peer(null)
	network.end_game()


func update_list():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	$HUD/Players/List.clear() # FIXME (non external variable for fragile link!)
	for player in network.players:
		$HUD/Players/List.add_item(network.players[player]) # FIXME (fragile link; make external)


func _process(_delta):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	handle_input()


func handle_input():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	if Input.is_action_just_pressed("tab"):
		update_list()
		$HUD/Players.show() # FIXME (fragile link; make external)
	if Input.is_action_just_released("tab"):
		$HUD/Players.hide() # FIXME (fragile link; make external)


puppet func play_anim(anim):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	knight.play_anim(anim)
