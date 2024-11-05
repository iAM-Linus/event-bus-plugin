@tool
extends EditorPlugin

func _enter_tree():
	# Add the EventBus singleton
	add_autoload_singleton("EventBus", "res://addons/event_bus_plugin/EventBus.gd")

func _exit_tree():
	remove_autoload_singleton("EventBus")
