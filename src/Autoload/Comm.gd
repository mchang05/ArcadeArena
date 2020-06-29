extends Node

signal connected
signal room_joined(room_id)
signal room_left
signal room_totalplayer_updated(total)

var _client 
var _socket
var _session : NakamaSession

var room_users = {}

func _ready():
	pass

func init(ip) -> void:
	_client = Nakama.create_client("defaultkey", ip, 7350, "http")
	_socket = Nakama.create_socket_from(_client)
	_socket.connect("connected", self, "_on_socket_connected")
	_socket.connect("closed", self, "_on_socket_closed")
	_socket.connect("received_error", self, "_on_socket_error")
	_socket.connect("received_channel_presence", self, "_on_channel_presence")
	
func authenticate(deviceid) -> void:
#	var deviceid = OS.get_unique_id()
	_session = yield(_client.authenticate_device_async(deviceid), "completed")
	if _session.is_exception():
		print("An error occured: %s" % _session)
		return
	connect_server()
	
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
	emit_signal("room_joined", channel.id)
	for p in channel.presences:
		room_users[p.user_id] = p
	print("Users in room: %s" % [room_users.keys()])

func leave_room(room_id) -> void:
	var result : NakamaAsyncResult = yield(_socket.leave_chat_async(room_id), "completed")
	if result.is_exception():
		print("An error occured: %s" % result)
		return
	emit_signal("room_left")
	
func _on_socket_connected() -> void:
	emit_signal("connected")
	
func _on_socket_closed() -> void:
	print("Server Close")
	
func _on_socket_error() -> void:
	print("Server Error")

func _on_channel_presence(p_presence : NakamaRTAPI.ChannelPresenceEvent) -> void:
	for p in p_presence.joins:
		room_users[p.user_id] = p
	for p in p_presence.leaves:
		room_users.erase(p.user_id)
	print("Users in room: %s" % [room_users.keys()])
	emit_signal("room_totalplayer_updated", room_users.size())
