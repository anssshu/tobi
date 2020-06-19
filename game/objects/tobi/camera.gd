extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	current = true
	if globals.current_level == 2:
		limit_left = 400
		limit_right = 5200
		limit_top = -500
		limit_bottom = 600
	if globals.current_level == 3:
		limit_left = -500
		limit_right = 5350
		limit_top = -500
		limit_bottom = 2400
	if globals.current_level == 4:
		limit_left = 0
		limit_right = 5692
		limit_top = 0
		limit_bottom = 2756
	if globals.current_level == 5:
		limit_left = -500
		limit_right = 5350
		limit_top = -500
		limit_bottom = 2400
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
