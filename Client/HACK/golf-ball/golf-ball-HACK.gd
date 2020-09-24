extends Node


"""
Brief Description
""" # FIXME (documentation missing)





func _on_golfballHACK_body_entered(body: Node):
	if body.role == "griefer":
		print("bleh")
		body.health.hurt(100)
