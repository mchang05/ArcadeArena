extends Node2D

var game_list = ["Pong", "Race"]
var room_scene := preload("res://src/Lobby/Room.tscn")

func _ready():
	Comm.connect("connected", self, "_on_comm_connected")
	Comm.authenticate()
	
	for game in game_list:
		var room = room_scene.instance()
		room.set_name(game)
		room.connect("entered", self, "_on_room_entered")
		$UI/Control/Games.add_child(room)
	pass

func _on_comm_connected() -> void:
	$UI/Control/Games.show()
	printt("Connected")

func _on_UUID_selected():
	Comm.connect_server()

func _on_room_entered(name):
	Comm.join_room(name)
