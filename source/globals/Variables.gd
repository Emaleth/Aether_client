extends Node

# LOCAL DATA INDEXES
var item_index := {}
var npc_index := {}
var ability_index := {}

# PLAYER DATA
var equipment_data := {}
var inventory_data := []
var ability_data := []
var action_bar_data := []
var recipe_data := []
var attributes_data := {}
var currency_data := {}
var resources_data := {}

# GENERAL DATA
var camera_rig = null
var player_actor = null
var user_interface = null
var world = null
var chatting := false

# CLIENT SETTINGS
var settings := {}

