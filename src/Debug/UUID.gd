extends Control

signal selected

var test_id := ["21d044b8-0d43-4228-9cc9-72423b5ffb76",
				"94c0a38d-8ed1-4e5b-82fe-2fbe5e6271ed",
				"c52b097a-2913-4d4a-8387-530fd6089356",
				"46ca058d-cbb7-41e5-8dfb-573f0a24c0f6",
				"0a21b8fd-4e35-4596-bf6c-296add189923",
				"82f1f3e2-a1f4-48d1-921c-d137378de829",
				"e0a72e67-f1ff-4e08-81f5-8797fadb1b47",
				"24ba8f9b-dc0e-46e7-81e6-f00ec0095439"]

func _ready():
	show()
	for id in test_id:
		$VBox/List.add_item(id, null, true)

func _on_List_item_activated(index):
	emit_signal("selected")
	queue_free()

func _on_BtnJoin_pressed():
	var id = $VBox/List.get_selected_items()[0]
	_on_List_item_activated(id)
