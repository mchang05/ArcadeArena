extends Node2D

export(String, "192.168.0.169", "192.168.1.110") var ip
var game_list = ["Pong", "Race"]
var game_banner := preload("res://src/Lobby/Room.tscn")

var pong_game = preload("res://src/Game/Pong/Pong.tscn")

func _ready():
	Comm.init(ip)
	Comm.connect("connected", self, "_on_comm_connected")
	Comm.connect("room_joined", self, "_on_room_joined")
	Comm.connect("room_left", self, "_on_room_left")
	
	for game in game_list:
		var room = game_banner.instance()
		room.set_name(game)
		room.connect("entered", self, "_on_room_selected")
		$UI/Control/Games.add_child(room)
	pass

func _on_comm_connected() -> void:
	$UI/Control/Games.show()

func _on_room_joined(room_id) -> void:
	$UI/Control.hide()
	var game = pong_game.instance();
	$Game.add_child(game)
	game.init(room_id)

func _on_room_left() -> void:
	$UI/Control.show()
	var game = $Game.get_child(0)
	$Game.remove_child(game)
	game.queue_free()
	
func _on_room_selected(name):
	Comm.join_room(name)

func _on_UUID_selected(id) -> void:
	Comm.authenticate(id)
