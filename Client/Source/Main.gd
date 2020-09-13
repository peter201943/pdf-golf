# tool # FIXME (add tool mode (or remove this script))
extends Control


"""briefly describe why this is here""" # FIXME (documentation missing)


func _ready():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	
	print("CLIENT.Main.Main._ready = loading")
	network.connect("connection_failed",    self, "_on_connection_failed")
	network.connect("connection_succeeded", self, "_on_connection_success")
	network.connect("game_ended",           self, "_on_game_ended")
	network.connect("game_error",           self, "_on_game_error")
	
	if OS.has_environment("USERNAME"):
		$Name/Value.text = OS.get_environment("USERNAME") # FIXME (fragile link; make external)
	else:
		var desktop_path = OS.get_system_dir(0).replace("\\", "/").split("/")
		$Name/Value.text = desktop_path[desktop_path.size()-2] # FIXME (fragile link; make external)
	
	print("CLIENT.Main.Main._ready() = done")


func _on_quit_button_pressed():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	get_tree().quit()


func _on_join_button_pressed():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	var player_name = $Name/Value.text # FIXME (fragile link; make external)
	if $Name/Value.text == "": # FIXME (fragile link; make external)
		$Info.text = "Invalid name" # FIXME (fragile link; make external)
		return
	
	var ip = $IP/Value.text.replace(" ", "")
	if !ip.is_valid_ip_address():
		$Info.text = "Invalid IP!" # FIXME (fragile link; make external)
		return
	
	var port = $Port/Value.value # FIXME (fragile link; make external)
	
	disable_ui("Connecting to the server...")
	network.join_game(ip, port, player_name)


func disable_ui(message=""):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	$Buttons/join_button.disabled = true # FIXME (fragile link; make external)
	$Name/Value.editable = false # FIXME (fragile link; make external)
	$IP/Value.editable = false # FIXME (fragile link; make external)
	$Port/Value.editable = false # FIXME (fragile link; make external)
	$Info.text = message # FIXME (fragile link; make external)


func enable_ui(message="", connected=false):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	$Buttons/join_button.disabled = false # FIXME (fragile link; make external)
	$Name/Value.editable = true # FIXME (fragile link; make external)
	$IP/Value.editable = true # FIXME (fragile link; make external)
	$Port/Value.editable = true # FIXME (fragile link; make external)
	$Info.text = message # FIXME (fragile link; make external)
	if connected:
		return
	yield(get_tree().create_timer(3.0), "timeout")
	$Info.text = ""  # FIXME (fragile link; make external)


func _on_game_error(error_text):
	"""briefly describe why this is here""" # FIXME (documentation missing)
	enable_ui(error_text)


func _on_game_ended():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	show()
	enable_ui()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_connection_failed():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	enable_ui("connection failed")


func _on_connection_success():
	"""briefly describe why this is here""" # FIXME (documentation missing)
	enable_ui("connected!", true)
