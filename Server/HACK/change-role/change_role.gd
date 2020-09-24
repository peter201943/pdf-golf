extends OptionButton

"""
""" # FIXME (doc missing)


signal MakeGriefer
signal MakeGolfer
signal MakeGolfBall
signal MakeTrap
signal MakeHouse


func _ready():
	add_item("Griefer", 0)
	add_item("Golfer", 1)
	add_item("Golf Ball", 2)
	add_item("Trap", 3)
	add_item("House", 4)





func _on_change_role_item_selected(id):
	
	if id == 0:
		print("Select Griefer")
		emit_signal("MakeGriefer")
	
	if id == 1:
		print("Select Golfer")
		emit_signal("MakeGolfer")
	
	if id == 2:
		print("Select Golf Ball")
		emit_signal("MakeGolfBall")
	
	if id == 3:
		print("Select Zap Trap")
		emit_signal("MakeTrap")
	
	if id == 4:
		print("Select House")
		emit_signal("MakeHouse")












