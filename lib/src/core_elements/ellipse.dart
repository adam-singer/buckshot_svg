part of buckshot_svg;

class Ellipse extends Shape
{
  FrameworkProperty<num> cx;
  FrameworkProperty<num> cy;
  FrameworkProperty<num> rx;
  FrameworkProperty<num> ry;

  Ellipse.register() : super.register();
  Ellipse();
  @override makeMe() => new Ellipse();

  @override initProperties(){
    super.initProperties();

    cx = new FrameworkProperty(this, 'cx',
      propertyChangedCallback: (num value){
        rawElement.attributes['cx'] = '$value';
      },
      converter: const StringToNumericConverter());

    cy = new FrameworkProperty(this, 'cy',
      propertyChangedCallback: (num value){
        rawElement.attributes['cy'] = '$value';
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

  @override createPrimitive(){
    rawElement = new SVGElement.tag('ellipse');
  }
}
