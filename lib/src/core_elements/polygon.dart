part of buckshot_svg;

class Polygon extends Shape
{
  FrameworkProperty<Collection<SurfacePoint>> points;

  Polygon.register() : super.register();
  Polygon();
  @override makeMe() => new Polygon();

  @override initProperties(){
    super.initProperties();

    points = new FrameworkProperty(this, 'points',
      propertyChangedCallback: (Collection<SurfacePoint> value){
        rawElement.attributes['points'] = _pointsToString();
      },
      converter: const StringToSurfacePointCollectionConverter());
  }

  @override createPrimitive(){
    rawElement = new SVGElement.tag('polygon');
  }

  String _pointsToString(){
    if (points.value == null || points.value.isEmpty) return '';
    final sb = new StringBuffer();

    points.value.forEach((p) => sb.add('${p.x},${p.y} '));
    return sb.toString().trim();
  }
}
