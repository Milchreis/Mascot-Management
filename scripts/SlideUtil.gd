class_name SlideUtil
extends Node

static func slideToX(main:Node, node:Node, x, duration:float=0.4):
	main.create_tween() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT) \
		.tween_property(node, "position", Vector2(x, 0), duration)

static func slideControl(main:Node, node:Control, from:Vector2, to:Vector2, duration:float):
	node.rect_position = from
	main.create_tween() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT) \
		.tween_property(node, "rect_position", to, duration)

static func slideInFromBottom(main:Node, node:Node, duration:float):
	node.position.y = 160
	main.create_tween() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT) \
		.tween_property(node, "position", Vector2(0, 0), duration)

static func slideOutToBottom(main:Node, node:Node, duration:float):
	main.create_tween() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT) \
		.tween_property(node, "position", Vector2(0, 160), duration)
