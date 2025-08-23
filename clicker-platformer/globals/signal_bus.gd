extends Node

#Game Control Signals
signal game_start(character:String, difficulty:String)

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
signal ability_unlock(panel)

#Floor Signals
signal floor_started()
signal room_started(room:Node)
signal room_ended(num:int, room:Node)

#Camera Signals
signal move_camera(pos)

#Enemy Signals
signal enemy_killed(enemy:Enemy)

#Player Signals
signal player_health_change
signal player_die
