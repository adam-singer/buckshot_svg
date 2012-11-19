part of buckshot_svg;

class SvgPlatformElement extends SurfaceElement
{
  SVGElement rawElement;

  SvgPlatformElement.register() : super.register();
  SvgPlatformElement(){
    svgPlatform.initElement(this);
  }
  @override makeMe() => null;

  @override initProperties(){
    super.initProperties();
  }

  @override void onUserSelectChanged(bool value){}
  @override void onWidthChanged(num value){}
  @override void onHeightChanged(num value){}
  @override void onCursorChanged(Cursors value){
    rawElement.style.cursor = '$value';
  }
  @override void onZOrderChanged(num value){}
  @override void onOpacityChanged(num value){
    rawElement.style.opacity = '$value';
  }
  @override void onVisibilityChanged(Visibility value){}
  @override void onDraggableChanged(bool draggable){}
  @override void onHitTestVisibilityChanged(HitTestVisibility value){
    rawElement.style.pointerEvents = '$value';
  }
}