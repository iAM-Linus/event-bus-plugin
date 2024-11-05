## Features

- **Global Event Emission**: Emit events from any part of your project.
- **Event Subscription**: Nodes can subscribe to events of interest.
- **In-Game Event Overview**: A toggleable UI to monitor events and listeners in real-time during gameplay.
- **Event Data Persistence**: Event and listener data are saved and can be reviewed after gameplay.
- **Editor Integration**: An Event Bus Overview panel in the editor to review event data.

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
