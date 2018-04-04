extends Reference

var node
var properties
var syncValues

func _init(node, properties):
	self.node = node
	self.properties = properties
	self.syncValues = {}
	
	for prop in properties:
		node.rset_config(prop, node.RPC_MODE_SLAVE)
		node.rset_config(prop, node.RPC_MODE_SLAVE)
		self.syncValues[prop] = node[prop]

func synchronize():
	for prop in properties:
		if syncValues[prop] != node[prop]:
			syncValues[prop] = node[prop]
			node.rset(prop, node[prop])