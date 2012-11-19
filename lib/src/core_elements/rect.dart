part of buckshot_svg;

class Rect extends Shape
{
  FrameworkProperty<num> x;
  FrameworkProperty<num> y;
  FrameworkProperty<num> rx;
  FrameworkProperty<num> ry;

  Rect.register() : super.register();
  Rect();
  @override makeMe() => new Rect();

  @override initProperties(){
    super.initProperties();

    x = new FrameworkProperty(this, 'x',
      propertyChangedCallback: (num value){
        rawElement.attributes['x'] = '$value';
      },
      converter: const StringToNumericConverter());

    y = new FrameworkProperty(this, 'y',
      propertyChangedCallback: (num value){
        rawElement.attributes['y'] = '$value';
      },
      converter: const StringToNumericConverter());

    rx = new FrameworkProperty(this, 'rx',
      propertyChangedCallback: (num value){
        rawElement.attributes['rx'] = '$value';
      },
      converter: const StringToNumericConverter());

    ry = new FrameworkProperty(this, 'ry',
      propertyChangedCallback: (num value){
        rawElement.attributes['ry'] = '$value';
      },
      converter: const StringToNumericConverter());
  }

  @override onWidthChanged(num value){
    rawElement.attributes['width'] = '$value';
  }

  @override onHeightChanged(num value){
    rawElement.attributes['height'] = '$value';
  }

  @override createPrimitive(){
    rawElement = new SVGElement.tag('rect');
  }
}
