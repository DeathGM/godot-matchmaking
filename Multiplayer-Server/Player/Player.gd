extends KinematicBody2D


remote func update_transform(transform):
	rpc_unreliable("Get_transform",transform)
