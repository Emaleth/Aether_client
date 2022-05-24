extends PanelContainer


func configure(_data):
	$HFlowContainer/AccountId.text = "Account id: %s" % _data
