extends Node2D

func _ready():
	# Subscribe to an event
	EventBus.subscribe("test_event", _on_test_event)
	
	# Emit the event after a short delay
	await get_tree().create_timer(1.0).timeout
	EventBus.emit("test_event", "Hello, EventBus!")

func _on_test_event(message):
	print("Received message:", message)

func _exit_tree():
	# Unsubscribe from the event
	EventBus.unsubscribe("test_event", _on_test_event)
