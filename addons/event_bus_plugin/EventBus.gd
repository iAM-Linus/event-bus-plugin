extends Node

# Reference to the data handler that manages event data persistence
var data_handler: EventBusDataHandler

# Reference to the in-game event overview UI
var event_overview: EventBusInGameOverview

# Dictionary to hold event names and their associated listener Callables
var _listeners: Dictionary = {}

func _ready() -> void:
	# Initialize the data handler for saving and loading event data
	data_handler = EventBusDataHandler.new()
	
	# Connect to the 'tree_exiting' signal to save data when the game is closing
	tree_exiting.connect(_on_tree_exiting)
	
	# Load and instantiate the in-game event overview UI
	event_overview = preload("res://addons/event_bus_plugin/EventBusInGameOverview.tscn").instantiate()
	add_child(event_overview)
	
	# Create a custom input action for toggling the event overview window
	var key: InputEventKey = InputEventKey.new()
	key.physical_keycode = KEY_B  # Assign the 'B' key
	InputMap.add_action("toggle_event_overview")
	InputMap.action_add_event("toggle_event_overview", key)

func _input(event) -> void:
	# Listen for the custom input action to toggle the event overview
	if event.is_action_pressed("toggle_event_overview"):
		event_overview.toggle_visibility()

func _notification(what) -> void:
	# Handle window close requests to save data before exiting
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		await save_event_bus_data()
		get_tree().quit()

func _on_tree_exiting() -> void:
	# Save event data when the scene tree is exiting
	save_event_bus_data()

func subscribe(event_name: String, listener: Callable) -> void:
	# Register a listener for a specific event
	if not _listeners.has(event_name):
		_listeners[event_name] = []
	_listeners[event_name].append(listener)
	print("EventBus: Subscribed listener to event '%s'." % event_name)
	
	# Update the data handler for persistence
	var listener_info = {
		"object_name": listener.get_object().name if is_instance_valid(listener.get_object()) else "<Invalid Object>",
		"method_name": listener.get_method()
	}
	if not data_handler.listeners_data.has(event_name):
		data_handler.listeners_data[event_name] = []
	data_handler.listeners_data[event_name].append(listener_info)

func unsubscribe(event_name: String, listener: Callable) -> void:
	# Unregister a listener from a specific event
	if _listeners.has(event_name):
		_listeners[event_name].erase(listener)
		if _listeners[event_name].is_empty():
			_listeners.erase(event_name)
	
	# Update the data handler to remove the listener information
	if data_handler.listeners_data.has(event_name):
		var listener_info = {
			"object_name": listener.get_object().name if is_instance_valid(listener.get_object()) else "<Invalid Object>",
			"method_name": listener.get_method()
		}
		data_handler.listeners_data[event_name].erase(listener_info)
		if data_handler.listeners_data[event_name].is_empty():
			data_handler.listeners_data.erase(event_name)

func emit(event_name: String, args) -> void:
	# Emit an event with the given arguments to all registered listeners
	if _listeners.has(event_name):
		var event_listeners = _listeners[event_name]
		# Duplicate the list to avoid modification during iteration
		var listeners = event_listeners.duplicate()
		print("EventBus: Emitting event '%s' to %d listeners." % [event_name, listeners.size()])
		for listener in listeners:
			if listener is Callable:
				# Call the listener method with the provided arguments
				listener.callv([args])
			else:
				push_error("EventBus: Listener is not a Callable.")
	else:
		print("EventBus: No listeners registered for event '%s'." % event_name)
	
	# Update the data handler with the emitted event information
	var timestamp = int(Time.get_unix_time_from_system())
	var emit_record: Dictionary = {
		"event_name": event_name,
		"args": args,
		"timestamp": timestamp
	}
	data_handler.emit_history_data.append(emit_record)

func save_event_bus_data() -> void:
	# Save the current state of event data to a file
	data_handler.save_event_data()

# Methods to access data (used by overviews)
func get_all_events() -> Array:
	# Return a list of all event names that have registered listeners
	return data_handler.listeners_data.keys()

func get_listeners_for_event(event_name: String) -> Array:
	# Return a list of listener information for a specific event
	if data_handler.listeners_data.has(event_name):
		return data_handler.listeners_data[event_name]
	return []

func get_emit_history() -> Array:
	# Return the history of emitted events
	return data_handler.emit_history_data
