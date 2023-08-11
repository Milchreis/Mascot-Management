class_name HScroller
extends Control

export var slideStep := 65
export var gap := 4
export var rightSidedScrollers := false
export var arrowGap := 0
export var width := 196

# little hack for max button: not sure why it's necessary.
# number of slideSteps before the right button is not visible
export var maxCorrection := 0

var slideOffset := 0

func _ready():
	$ScrollContainer.rect_min_size.x = width
	$ScrollContainer.rect_size.x = width
	$ScrollContainer/Container.set("custom_constants/separation", gap)
	$SlideRightBtn.rect_position.x += width - 196 + arrowGap
	$SlideLeftBtn.rect_position.x += width - 196 - arrowGap
	
	if rightSidedScrollers:
		$SlideLeftBtn.rect_position.x = $SlideRightBtn.rect_position.x
		$SlideLeftBtn.rect_position.y += 20

func _process(_delta):
	$SlideLeftBtn.visible = slideOffset > 0
	$SlideRightBtn.visible = slideOffset < getMaxScroll() - slideStep - gap - (maxCorrection*slideStep)

func reset():
	slideOffset = 0

func getItems():
	return $ScrollContainer/Container.get_children()

func removeItem(item:Node):
	$ScrollContainer/Container.remove_child(item)

func addItem(item:Node):
	$ScrollContainer/Container.add_child(item)

func getMaxScroll() -> int:
	var totalEvents = $ScrollContainer/Container.get_children().size()
	var gaps = gap * totalEvents
	return slideStep * totalEvents + gaps

func onSlideRight():
	if slideOffset == getMaxScroll(): return
	
	var totalEvents = getItems().size()
	var maxScroll = slideStep * totalEvents + gap
	
	slideOffset = min(maxScroll, slideOffset + slideStep + gap)
	
	$ClickPlayer.pitch_scale = 1.0
	$ClickPlayer.play()
	
	SlideUtil.jumpControl(self, $SlideRightBtn)
	SlideUtil.slideInScrollContainer(self, $ScrollContainer, slideOffset, 0.4)

func onSlideLeft():
	if slideOffset == 0: return
	slideOffset = max(0, slideOffset - slideStep - gap)
	
	$ClickPlayer.pitch_scale = 2.0
	$ClickPlayer.play()
	
	SlideUtil.jumpControl(self, $SlideLeftBtn)
	SlideUtil.slideInScrollContainer(self, $ScrollContainer, slideOffset, 0.4)
