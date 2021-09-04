extends Node

var opponent_server = 0
var opponent_client = 0
var lobby_id
var players_in_queue = []
var lobby = {}
var instanced = []
var players_online = []

remote func update_lobby(list):
	lobby = list

func get_online_players():
	rpc_id(1,"get_online_players")
	
remote func reveiced_online_players(list):
	players_online = list
	print("Players online: ",players_online)
	
func search_game():
	rpc_id(1,"player_join_queue",get_tree().get_network_unique_id())
func remove_search():
	rpc_id(1,"player_leave_queue",get_tree().get_network_unique_id())
	
remote func get_queue(list):
	players_in_queue = list
	print(players_in_queue)      

remote func init_server(player,lobbyid):
	opponent_client = player
	opponent_server = get_tree().get_network_unique_id()
	lobby_id = lobbyid
	
remote func init_client(player,lobbyid):
	opponent_server = player
	opponent_client = get_tree().get_network_unique_id()
	lobby_id = lobbyid

func enter_game():

	var world = preload("res://Main/Test.tscn").instance()
	world.name = str(opponent_server)
	world.add_to_group(str(opponent_server))
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("UI").queue_free()
	rpc_id(1,"enter_game",opponent_server,opponent_client)
func return_ui():
	opponent_client = 0
	opponent_server = 0
	lobby_id = 0
	get_tree().change_scene("res://UI/UI.tscn")


func check_player_in_lobby(player_id):
	rpc_id(1,"chck_pl_in_lob",player_id)
func send_finished_game(game_id,who):
	rpc_id(1,"received_finished_game",game_id,who)
remote func game_finished_bro(which):
	get_tree().get_nodes_in_group(str(opponent_server))[0].end_game(get_tree().get_network_unique_id(),false)
	
