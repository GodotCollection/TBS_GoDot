extends Node2D

# Container for the entire level
# Add extra functions that might be needed here

var level_music = preload("res://assets/music/Fodlan Winds.ogg")

var chapter_title = "4\nThe Great Fortress Line"
var prep_music_choice = "B"
var money_to_add = 1500

var enemy_commander_name = "Byzantine"

func _ready():
	# Container for this
	BattlefieldInfo.level_container = self
	
	# Set Camera to new spot
	BattlefieldInfo.main_game_camera.position = Vector2(0, 0)
	
	# Set cursor
	BattlefieldInfo.cursor.position = Vector2(0,0)
	
	# Set Music for this level
	BattlefieldInfo.music_player.get_node("AllyLevel").stream = level_music
	
	# Set Victory condition
	BattlefieldInfo.victory = false
	BattlefieldInfo.victory_system.clear()
	BattlefieldInfo.victory_system.victory_condition_state = Victory_Checker.SEIZE
	
	# Set enemy commander
	BattlefieldInfo.enemy_commander = BattlefieldInfo.enemy_units[enemy_commander_name]
	
	# Reset Events and manager
	BattlefieldInfo.event_system.clear()
	BattlefieldInfo.event_system.add_event(L4_Event_Part10.new())
	
	# Add money
	if !BattlefieldInfo.save_load_system.is_loading_level:
		BattlefieldInfo.money += money_to_add
	
	# Add the players from the y sort to the battle field y sort
	for player_unit in BattlefieldInfo.y_sort_player_party.get_children():
		BattlefieldInfo.y_sort_player_party.remove_child(player_unit)
		BattlefieldInfo.current_level.get_node("YSort").add_child(player_unit)
	
	# Prep mode
	preperation_mode()
	
	# Show Ally units
	for ally_unit in BattlefieldInfo.ally_units.values():
		ally_unit.visible = true
	
	# Remove dark from level
	BattlefieldInfo.battlefield_container.modulate = Color(1,1,1,1)
	
	# Remove other one
	if has_node("root/Level/Chapter 4"):
		get_node("/root/Level/Chapter 4").queue_free()

func next_level():
	# Remove any ally units that are still alive
	for unit in BattlefieldInfo.current_level.get_node("YSort").get_children():
		if unit.UnitMovementStats.is_ally:
			BattlefieldInfo.current_level.get_node("YSort").remove_child(unit)
			BattlefieldInfo.y_sort_player_party.add_child(unit)

func start_battle():
	# Start the level
	BattlefieldInfo.event_system.start_events_queue()
	BattlefieldInfo.music_player.get_node("AllyLevel").play(0)

func preperation_mode():
	# Turn on prep
	BattlefieldInfo.preparation_screen.start(chapter_title, BattlefieldInfo.victory_text, "res://Scenes/Intro Screen/Intro Screen.tscn", prep_music_choice)
	
	# Show Cursor
	BattlefieldInfo.cursor.visible = true
	
	# Show UI
	BattlefieldInfo.battlefield_ui.get_node("Battlefield HUD").visible = true
	
	# Turn off turn manager
	BattlefieldInfo.turn_manager.turn = Turn_Manager.WAIT
	
	# Set all units to move for the allies
	for ally_unit in BattlefieldInfo.ally_units.values():
		ally_unit.UnitActionStatus.set_current_action(Unit_Action_Status.MOVE)
