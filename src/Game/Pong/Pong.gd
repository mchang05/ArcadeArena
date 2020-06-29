extends Node2D

var room_id := ""

func _ready():
	Comm.connect("room_totalplayer_updated", self, "_on_totalplayer_updated")
	

func init(id) -> void:
	room_id = id

func _on_BtnLeave_pressed() -> void:
	Comm.leave_room(room_id);

func _on_totalplayer_updated(total) -> void:
	$UI/Control/Online.text = String(total)

