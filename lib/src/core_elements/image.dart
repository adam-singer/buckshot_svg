part of buckshot_svg;

class Image extends SvgPlatformElement
{
  FrameworkProperty<String> uri;
  FrameworkProperty<num> x;
  FrameworkProperty<num> y;

  Image.register() : super.register();
  Image();
  @override makeMe() => new Image();

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

    uri = new FrameworkProperty(this, 'uri',
      propertyChangedCallback:(String value){
        //Does not work.
        //BUG: http://www.dartbug.com/5395
        rawElement.attributes['xlink:href'] = value;
      });
  }

  @override onWidthChanged(num value){
    rawElement.attributes['width'] = '${value}px';
  }

  @override onHeightChanged(num value){
    rawElement.attributes['height'] = '${value}px';
  }

  @override createPrimitive(){
    rawElement = new SVGElement.tag('image');
  }
}
