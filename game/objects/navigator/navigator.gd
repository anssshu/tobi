extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 10
export var active = true
var move = {
	left = Vector2(-1,0),
	right =  Vector2(1,0),
	up = Vector2(0,-1),
	down = Vector2(0,1)
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#position = get_tree().root.size/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		var left = Input.is_action_pressed("ui_left")
		var right = Input.is_action_pressed("ui_right")
		var up = Input.is_action_pressed("ui_up")
		var down = Input.is_action_pressed("ui_down")
		var v = Vector2()
		var zoomIn = Input.is_action_pressed("ui_zoom_in")
		var zoomOut = Input.is_action_pressed("ui_zoom_out")
		
		if zoomIn:
			$Camera2D.zoom += Vector2(.01,.01)
		if zoomOut:
			$Camera2D.zoom -= Vector2(.01,.01)
		if left:
			v = move.left*speed
		elif right:
			v = move.right*speed
		elif up:
			v = move.up*speed
		elif down:
			v = move.down*speed
		else:
			v = Vector2()
			
		#update position
		position += v
	
	