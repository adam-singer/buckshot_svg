part of buckshot_svg;

class Line extends Shape
{
  FrameworkProperty<num> x1;
  FrameworkProperty<num> y1;
  FrameworkProperty<num> x2;
  FrameworkProperty<num> y2;

  Line.register() : super.register();
  Line();
  @override makeMe() => new Line();

  @override initProperties(){
    super.initProperties();

    x1 = new FrameworkProperty(this, 'x1',
      propertyChangedCallback: (num value){
        rawElement.attributes['x1'] = '$value';
      },
      converter: const StringToNumericConverter());

    y1 = new FrameworkProperty(this, 'y1',
      propertyChangedCallback: (num value){
        rawElement.attributes['y1'] = '$value';
      },
      converter: const StringToNumericConverter());

    x2 = new FrameworkProperty(this, 'x2',
      propertyChangedCallback: (num value){
        rawElement.attributes['x2'] = '$value';
      },
      converter: const StringToNumericConverter());

    y2 = new FrameworkProperty(this, 'y2',
      propertyChangedCallback: (num value){
        rawElement.attributes['y2'] = '$value';
      },
      converter: const StringToNumericConverter());
  }

  @override createPrimitive(){
    rawElement = new SVGElement.tag('line');
  }
}
