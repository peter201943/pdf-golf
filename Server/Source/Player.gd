# tool # FIXME (add tool mode)
extends KinematicBody

"""briefly describe why this is here""" # FIXME (documentation missing)

onready var camera = $Pivot/Camera # FIXME (non external variable for fragile link!)

const MOTION_SPEED = 8

puppet var puppet_transform
puppet var puppet_motion = Vector3()
var motion = Vector3()

var random_number_generator = RandomNumberGenerator.new()

export var speed = 100
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
export var mouse_sensitivity = 0.003

var last_motion
var last_transform

onready var knight = $knight # FIXME (non external variable for fragile link!)


func _ready():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	$HUD/Panel.hide() # FIXME (non external variable for fragile link!)
	$HUD/Players.hide() # FIXME (non external variable for fragile link!)
	if is_network_master():
		camera.current = true
		set_color()
	puppet_transform = transform
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func set_color():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	var material = $Model.get_surface_material(0) # FIXME (non external variable for fragile link!)
	random_number_generator.randomize()
	var r = random_number_generator.randf_range(0.0, 1.0)
	random_number_generator.randomize()
	var g = random_number_generator.randf_range(0.0, 1.0)
	random_number_generator.randomize()
	var b = random_number_generator.randf_range(0.0, 1.0)
	var color = Vector3(r, g, b).normalized()
	material.albedo_color = Color(color.x, color.y, color.z, 1.0)


func _unhandled_input(event):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	var mouse_motion = event is InputEventMouseMotion
	var mouse_captured = Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("shoot"):
		if !mouse_captured:
			$HUD/Panel.hide() # FIXME (non external variable for fragile link!)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_cancel"):
		if mouse_captured:
			release_mouse()
			$HUD/Panel.show() # FIXME (non external variable for fragile link!)
	if mouse_motion and mouse_captured:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity) # FIXME (non external variable for fragile link!)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -0.8, 0.8) # FIXME (non external variable for fragile link!)


func _physics_process(delta):
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
		
		var anim
		
		if motion.x != 0 or motion.z != 0:
			anim = "walk"
		else:
			anim = "idle"
		
		play_anim(anim)
		if last_motion != motion:
			rpc('play_anim', anim)
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
	$Name/Viewport/GUI/Player.text = player


func _on_cancel_button_pressed():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	$HUD/Panel.hide()
	release_mouse()


func capture_mouse():
	# DELETEME (unnecessary function)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func release_mouse():
	# DELETEME (unnecessary function)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_quit_button_pressed():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	get_tree().set_network_peer(null)
	#network.end_game()


func update_list():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	$HUD/Players/List.clear() # FIXME (non external variable for fragile link!)
	#for player in network.players:
	#	$HUD/Players/List.add_item(network.players[player])


func _process(_delta):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	handle_input()


func handle_input():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	if Input.is_action_just_pressed("tab"):
		update_list()
		$HUD/Players.show() # FIXME (non external variable for fragile link!)
	if Input.is_action_just_released("tab"):
		$HUD/Players.hide() # FIXME (non external variable for fragile link!)


puppet func play_anim(anim):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	knight.play_anim(anim)
