extends RigidBody


"""
https://godotengine.org/qa/60362/how-can-i-properly-sync-rigidbodies-in-a-3d-multiplayer-game
""" # FIXME (documentation missing)


puppet var puppet_transform
puppet var puppet_translation: Vector3

var is_puppet: bool
const delay_max: float = 0.5
var delay: float
var updates: int


func _ready():
	is_puppet = false
	if is_network_master():
		is_puppet = true
	delay = 0.0
	updates = 0


func _physics_process(delta):
	delay += delta
	if delay >= delay_max:
		delay = 0.0
		updates += 1
		if not is_puppet:
			print("updating... (" + str(updates) + ")")
			rset("puppet_transform", transform)
			rset("puppet_translation", translation)
		if is_puppet:
			print("getting updates... (" + str(updates) + ")")
			transform = puppet_transform
			translation = puppet_translation


func _on_golfballHACK_body_entered(body: Node):
	if body.role == "griefer":
		print("bleh")
		rpc_id(int(body.name), "body.health.hurt", 100)
