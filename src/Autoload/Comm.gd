extends Node

signal connected

var _client := Nakama.create_client("defaultkey", "192.168.0.169", 7350, "http")
var _socket := Nakama.create_socket_from(_client)
var _session : NakamaSession

func _ready():
	_socket.connect("connected", self, "_on_socket_connected")
	_socket.connect("closed", self, "_on_socket_closed")
	_socket.connect("received_error", self, "_on_socket_error")

func authenticate() -> void:
	var deviceid = OS.get_unique_id()
	_session = yield(_client.authenticate_device_async(deviceid), "completed")
	if _session.is_exception():
		print("An error occured: %s" % _session)
		return
	
	
func get_account_info() -> void:
	var account : NakamaAPI.ApiAccount = yield(_client.get_account_async(_session), "completed")
	if account.is_exception():
		print("An error occured: %s" % account)
		return
	var user = account.user
	print("User id '%s' and username '%s'." % [user.id, user.username])
	print("User's wallet: %s." % account.wallet)
	
func connect_server() -> void:
	yield(_socket.connect_async(_session), "completed")

func join_room(room_name) -> void:
	var persistence = true
	var hidden = false
	var type = NakamaSocket.ChannelType.Room
	var channel : NakamaRTAPI.Channel = yield(_socket.join_chat_async(room_name, type, persistence, hidden), "completed")
	if channel.is_exception():
		print("An error occured: %s" % channel)
		return
	print("Now connected to channel id: '%s'" % [channel.id])
	
func _on_socket_connected() -> void:
	emit_signal("connected")
	
func _on_socket_closed() -> void:
	print("Server Close")
	
func _on_socket_error() -> void:
	print("Server Error")
