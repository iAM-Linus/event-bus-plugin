## Overview

The Event Bus plugin provides a centralized event management system for Godot 4 projects. It allows nodes to communicate with each other by emitting and listening to events without needing direct references, promoting decoupled and maintainable code architecture.

## Features

- **Global Event Emission**: Emit events from any part of your project.
- **Event Subscription**: Nodes can subscribe to events of interest.
- **In-Game Event Overview**: A toggleable UI to monitor events and listeners in real-time during gameplay.
- **Event Data Persistence**: Event and listener data are saved and can be reviewed after gameplay.

## Installation

### Copy the Plugin Files

Place the `event_bus_plugin` folder into your project's `addons` directory:

```
res://addons/event_bus_plugin/
```

### Enable the Plugin

1. In the Godot editor, go to **Project > Project Settings > Plugins**.
2. Find `EventBusPlugin` in the list and set it to **Active**.

### Verify Autoload

- The plugin automatically adds the `EventBus` singleton to the Autoload list.
- You can confirm this in **Project > Project Settings > Autoload**.

## Usage

### Emitting Events

To emit an event, call the `emit` method of the `EventBus` singleton, providing the event name and any arguments:

```gdscript
# Example: Emitting an event named "player_scored" with a score value
EventBus.emit("player_scored", score_value)
```

### Subscribing to Events

To listen for events, a node should subscribe to the event using the `subscribe` method and provide a callback function:

```gdscript
func _ready():
    # Subscribe to the "player_scored" event
    EventBus.subscribe("player_scored", _on_player_scored)

func _on_player_scored(score_value):
    # Handle the event
    print("Player scored:", score_value)

func _exit_tree():
    # Unsubscribe from the event when the node is removed
    EventBus.unsubscribe("player_scored", _on_player_scored)
```

**Note**: It's important to unsubscribe from events in the `_exit_tree` function to prevent memory leaks and dangling references.

### Using the In-Game Event Overview

The plugin includes an in-game UI to visualize events and listeners during gameplay.

#### Toggle Visibility

- Press the assigned key (default is `B`) to show or hide the event overview.
- The key binding is defined in the `_ready` function of `EventBus.gd` and can be changed.

#### Features

- Lists all registered events and their listeners.
- Displays the history of emitted events with timestamps.

### Customizing the Toggle Key

To change the key used to toggle the in-game event overview:

1. Open `EventBus.gd`.
2. In the `_ready` function, modify the `key.physical_keycode` assignment:

   ```gdscript
   key.physical_keycode = KEY_YOUR_DESIRED_KEY
   ```

   Replace `KEY_YOUR_DESIRED_KEY` with the desired key constant (e.g., `KEY_F1`, `KEY_T`).

### Accessing Event Data

You can access event and listener data programmatically if needed:

```gdscript
var all_events = EventBus.get_all_events()
for event_name in all_events:
    var listeners = EventBus.get_listeners_for_event(event_name)
    print("Event:", event_name, "Listeners:", listeners)
```

## Advanced Features

### Data Persistence

- Event data is saved to `user://event_bus_data.json` when the game exits.
- The data includes registered listeners and the emit history.
- This allows for post-game analysis of event flows and listener registrations.

### Extending the Plugin

- **Custom Event Handling**: You can extend the `EventBus` class to include custom logic for event handling.
- **UI Customization**: Modify the `EventBusInGameOverview.tscn` scene to customize the in-game UI appearance and layout.
- **Additional Data**: Store additional information in events by extending the `emit` method and the data structures.

## Best Practices

- **Decouple Components**: Use the Event Bus to reduce direct dependencies between nodes.
- **Clean Up**: Always unsubscribe from events when a node is no longer needed.
- **Avoid Name Collisions**: Use unique event names, possibly namespaced (e.g., `"player/scored"`).

## Troubleshooting

### Events Not Emitting

- Ensure that event names are consistent between `emit` and `subscribe`.
- Verify that listeners are correctly registered.

### In-Game Overview Not Showing

- Make sure the toggle key is correctly assigned and not conflicting with other input actions.
- Confirm that the `EventBusInGameOverview` scene is correctly loaded and added as a child.

### Event Data Not Saving

- Check for errors in the console regarding file access.
- Ensure the `save_event_bus_data` function is called when the game exits.

## Conclusion

The Event Bus plugin is a powerful tool to manage events within your Godot projects. By following this documentation, you should be able to integrate it into your project effectively and leverage its features to improve your game's architecture and debugging capabilities.
