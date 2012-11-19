part of buckshot_svg;

class Group extends SvgPlatformElement implements FrameworkContainer
{
  final ObservableList<SvgPlatformElement> children =
      new ObservableList<SvgPlatformElement>();

  Group.register() : super.register();
  Group(){
    stateBag[FrameworkObject.CONTAINER_CONTEXT] = children;
    children.listChanged + onChildrenChanged;
  }
  @override makeMe() => new Group();

  get containerContent => children;

  void onChildrenChanged(_, ListChangedEventArgs args){
    args.oldItems.forEach((SvgPlatformElement oldChild){
      oldChild.rawElement.remove();
      oldChild.parent = null;
    });

    args.newItems.forEach((SvgPlatformElement newChild){
      rawElement.elements.add(newChild.rawElement);
      newChild.parent = this;
    });
  }

  @override createPrimitive(){
    rawElement = new SVGElement.tag('g');
  }
}
