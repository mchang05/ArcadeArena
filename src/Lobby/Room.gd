extends Control

signal entered (name)

func _ready():
	pass

func set_name(room_name):
	$Label.text = room_name


func _on_Room_pressed():
	emit_signal("entered", $Label.text)
