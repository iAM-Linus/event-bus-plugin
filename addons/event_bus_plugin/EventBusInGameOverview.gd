extends CanvasLayer
class_name EventBusInGameOverview

# References to UI elements
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton
@onready var content_container: VBoxContainer = $Panel/VBoxContainer/ScrollContainer/ContentContainer

# Load custom label settings for consistent UI styling
var label_settings: LabelSettings = preload("res://addons/event_bus_plugin/fonts/LabelSettings.tres")

# Timer for periodic updates of the overview
var timer: Timer

# Visibility flag for the overview UI
var is_visible := false:
	get:
		return is_visible
	set(value):
		is_visible = value

func _ready() -> void:
	# Connect the close button to hide the overview
	close_button.pressed.connect(hide_overview)
	set_visibility(false)
	
	# Initialize and start the timer for updating the overview every 2 seconds
	timer = Timer.new()
	timer.autostart = true
	timer.one_shot = false
	timer.wait_time = 2.0
	add_child(timer)

func _process(delta: float) -> void:
	# Wait for the timer timeout signal to update the overview
	await timer.timeout
	update_overview()

func set_visibility(value: bool) -> void:
	# Set the visibility of the overview UI
	is_visible = value
	visible = value

func toggle_visibility() -> void:
	# Toggle the visibility of the overview UI
	set_visibility(not is_visible)

func hide_overview() -> void:
	# Hide the overview UI
	set_visibility(false)

func update_overview() -> void:
	# Clear existing content in the overview
	for child in content_container.get_children():
		child.queue_free()
	
	# Display the list of listeners
	var listeners_label: Label = Label.new()
	listeners_label.label_settings = label_settings
	listeners_label.text = "Listeners:"
	content_container.add_child(listeners_label)

	var events = EventBus.get_all_events()
	for event_name in events:
		var event_label = Label.new()
		event_label.label_settings = label_settings
		event_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		event_label.text = "- Event: " + event_name
		content_container.add_child(event_label)
		
		var listeners = EventBus.get_listeners_for_event(event_name)
		for listener_info in listeners:
			var object_name = listener_info.get("object_name", "<Unknown>")
			var method_name = listener_info.get("method_name", "<Unknown>")
			var listener_label: Label = Label.new()
			listener_label.label_settings = label_settings
			listener_label.text = "    - Listener: %s.%s" % [object_name, method_name]
			content_container.add_child(listener_label)

	# Display the emit history
	var history_label: Label = Label.new()
	history_label.label_settings = label_settings
	history_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	history_label.text = "\nEmit History:"
	content_container.add_child(history_label)

	var emit_history = EventBus.get_emit_history()
	for record in emit_history:
		var timestamp = record["timestamp"]
		var datetime = Time.get_datetime_dict_from_unix_time(timestamp)
		var time_str = "%02d:%02d:%02d" % [datetime.hour, datetime.minute, datetime.second]
		var emit_label: Label = Label.new()
		emit_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		emit_label.label_settings = label_settings
		emit_label.text = "[%s] Event: %s Args: %s" % [time_str, record["event_name"], record["args"]]
		content_container.add_child(emit_label)
