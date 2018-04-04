extends Reference

var node
var properties

func _init(node, properties):
	self.node = node
	self.properties = properties
	
	for prop in properties:
		node.rset_config(prop, node.RPC_MODE_SLAVE)
		node.rset_config(prop, node.RPC_MODE_SLAVE)

func synchronize():
	for prop in properties:
		node.rset_unreliable(prop, node[prop])