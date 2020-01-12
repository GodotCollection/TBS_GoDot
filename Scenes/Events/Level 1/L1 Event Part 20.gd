extends Event_Base

class_name L1_Event_Part_20

# Event Description:
# Bandit Leader talks

# Dialogue between the characters
var dialogue = [
	"Bandit Leader:\n\nWhat do we have here?!?",
	"Bandit Leader:\n\nA princess and her knight!",
	"Bandit Leader:\n\nThe Almaryans will pay me handsomely for your head!",
	"Bandit Leader:\n\nGet her boys! 20 extra silver to whoever brings me her head, 40 if alive!"
]

# Set Names for Debug
func _init():
	event_name = "Level 1 Bandit Leader Talk"
	event_part = "Part 20"

func start():
	# Start music
	BattlefieldInfo.music_player.get_node("AllyLevel").play(0)
	
	# Register to the dialogue system
	BattlefieldInfo.message_system.connect("no_more_text", self, "move_camera")
	
	# Start Text
	BattlefieldInfo.message_system.set_position(Messaging_System.BOTTOM)
	enable_text(dialogue)

# Move Camera back
func move_camera():
	# New Position
	var new_position_for_camera = Vector2(0,80)
	
	# Move Camera and Remove old camera
	BattlefieldInfo.main_game_camera.get_node("Tween").connect("tween_all_completed", self, "event_complete")
	BattlefieldInfo.main_game_camera.get_node("Tween").interpolate_property(BattlefieldInfo.main_game_camera, "position", BattlefieldInfo.main_game_camera.position, new_position_for_camera, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	BattlefieldInfo.main_game_camera.current = true
	BattlefieldInfo.main_game_camera.get_node("Tween").start()