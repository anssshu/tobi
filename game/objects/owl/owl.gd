extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var val = 0
onready var bb = $RichTextLabel
var text = ["hi tobi how are you ?",
"I am Oonu.","I know who took your toy.","It was the Momu cat.",
 "He was running towards the woods.",
"Goto the woods  you will find Momu there! ."]
var page = 0
var current_text = text[0]
var i = 0
var j = 0
var buff=""
# Called when the node enters the scene tree for the first time.
	
	
func _ready():
	
	i=0
	
	
	
	#$text_timer.start()
	#$text.text = "Test"
func set_text(text):
	$text.text = text
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_text_timer_timeout():
	$text_bg.show()
	$text.show()
	
	#get_node("/root/ground/CanvasLayer/owl").show()
	#set_text(current_text)
	#if i<(len(text)-1):
		#i+=1
	#else:
		##$text_timer.stop() 
	#current_text =  text[i]

	process_text()
func process_text():
	if i<(len(text)):
		var t = text[i].split(" ")
		if j == len(t)-2:
			$text_timer.wait_time = 1
		else:
			$text_timer.wait_time = .2
		
		if j<(len(t)):
			print(t,i,j)
			buff =buff+" "+ t[j]
			j+=1
			
		else:
			if i < (len(text)-1):
				buff = ''
			j=0
			i+=1
		set_text(buff)
		
	else:
		i=0
		$text_timer.stop() 
		buff = ""
		text = ["hurry! tobi , catch the naughty cat"]
		#at the end of talk blink arrow
		var arrow = get_node("root/ground/arrow")

			
		
		

func _on_Area2D_body_entered(body):
	if body.name == "player":
		$text_timer.start()


