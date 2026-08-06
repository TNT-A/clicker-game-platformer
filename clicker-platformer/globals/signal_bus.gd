extends Node

#Game Control Signals
signal game_start(character:String, difficulty:String)
signal game_end

#State Change Signals
signal transitioned(node, state)

#Clicker Panel Signals
signal update_selected()
signal update_active()

#Registration Signals
signal register_panel(clicker_panel)
signal register_player(pot_player)

#Ability Signals
signal ability_use(num, damage)
signal ability_change()
signal ability_scrolled()
signal ability_pickup_popup()

#Ability Pickup Signals
signal ability_popup(ability_resource : Resource)
signal ability_fade_out()

#Floor Signals
signal floor_started()
signal floor_ended()
signal room_started(room:RoomBase)
signal boss_room_started(room:RoomBase)
signal swap_by_slot(og_room_slot : int, new_room_slot : int)
signal swap_to_shop()
signal room_setup(room_slot : int)
signal room_ended(num:int, room:RoomBase)

#Effect Signals
signal frame_freeze(timescale: float, duration: float)

#Enemy Signals
signal enemy_killed(enemy:Enemy)
signal enemy_spawned(enemy:Enemy, is_boss:bool)

#Boss Signals
signal phase_end(phase_num : int)
signal boss_start(enemy:Enemy)
signal boss_hit()
signal boss_health_changed(new_value : float, max_value)

#Player Signals
signal player_health_change
signal player_die

#Upgrade Signals
signal health_pickup_get(num : int)
signal coin_pickup_get
signal upgrade_pickup_get
signal ability_pickup_get

#Draggable Signals / Ability Drag SIgnals
signal drag_recieved(drag_zone : Area2D, drag_info : Resource, draggable : Draggable)
signal forward_to_host(host : Node, drag_info : Resource, draggable : Draggable)
signal drag_used(draggable : Draggable)

#Camera Signals
signal move_camera(pos, margins)
signal camera_moved(new_position : Vector2)

#Tool Signals
signal autoclick()
