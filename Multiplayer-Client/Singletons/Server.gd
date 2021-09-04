extends Node


var ip = "127.0.0.1"
var port = 1909
var peer = NetworkedMultiplayerENet.new()


func _ready():
	ConnectToServer()
	get_tree().connect("connected_to_server",self,"_connected")
	get_tree().connect("connection_failed",self,"_failed")
func ConnectToServer():
	peer.create_client(ip,port)
	get_tree().network_peer = peer
	
func _connected():
	print("Connected to Server")
	print("My network id: ",get_tree().get_network_unique_id())
func _failed():
	print("Failed to connect")
	
