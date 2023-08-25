class_name SlideUtil
extends Node

static func jumpControl(main:Node, node:Control, heigth:int=5, duration:float=0.25) -> Tween:
	var x = node.rect_position.x
	var y = node.rect_position.y
	var tween = main.create_tween() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(node, "rect_position", Vector2(x, y-heigth), duration*0.25)
	tween.tween_property(node, "rect_position", Vector2(x, y), duration*0.75)
	return tween

static func jump(main:Node, node:Node, heigth:int=5, duration:float=0.25, delay=0.0) -> Tween:
	var x = node.position.x
	var y = node.position.y
	var tween = main.create_tween() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(node, "position", Vector2(x, y-heigth), duration*0.25).set_delay(delay)
	tween.tween_property(node, "position", Vector2(x, y), duration*0.75)
	return tween
		
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

static func slideInScrollContainer(main, container:ScrollContainer, to:int, duration:float):
	main.create_tween() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT) \
		.tween_property(container, "scroll_horizontal", to, duration)

static func slideOutToBottom(main:Node, node:Node, duration:float):
	var tween = main.create_tween() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)
		
	tween.tween_property(node, "position", Vector2(0, 160), duration)
	return tween
