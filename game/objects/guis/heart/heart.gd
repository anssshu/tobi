extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(globals.life):
		var s = Sprite.new()
		s.texture = preload("res://objects/guis/heart/heart.png")
		s.name = "heart"+str(i)
		s.centered = false
		s.position = Vector2(20+32*i,20)
		add_child(s)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var n = get_child_count()
	var l =globals.life
	if n-l >0:
		get_child(l).hide()
		
		
		