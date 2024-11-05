extends Node
class_name EventBusDataHandler

# Dictionary to store listener information for each event
var listeners_data: Dictionary = {}

# Array to store the history of emitted events
var emit_history_data: Array = []

# File path to save and load event data
const DATA_FILE_PATH = "user://event_bus_data.json"

func save_event_data() -> void:
	# Save the listener data and emit history to a JSON file
	var data = {
		"listeners": listeners_data,
		"emit_history": emit_history_data
	}
	var file = FileAccess.open(DATA_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("EventBusDataHandler: Data saved to", DATA_FILE_PATH)
	else:
		push_error("EventBusDataHandler: Failed to save data to file.")

func load_event_data() -> Dictionary:
	# Load the listener data and emit history from the JSON file
	var json = JSON.new()
	var file = FileAccess.open(DATA_FILE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var error = json.parse(content)
		if error == OK:
			var data = json.data
			if typeof(data) == TYPE_DICTIONARY:
				listeners_data = data.get("listeners", {})
				emit_history_data = data.get("emit_history", [])
				return data
			else:
				push_error("EventBusDataHandler: Invalid data format in file.")
	else:
		print("EventBusDataHandler: Data file not found.")
	return {}
