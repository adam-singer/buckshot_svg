part of buckshot_svg;

class PolyLine extends Shape
{
  FrameworkProperty<Collection<SurfacePoint>> points;

  PolyLine.register() : super.register();
  PolyLine();
  @override makeMe() => new PolyLine();

  @override initProperties(){
    super.initProperties();

    points = new FrameworkProperty(this, 'points',
      propertyChangedCallback: (Collection<SurfacePoint> value){
        rawElement.attributes['points'] = _pointsToString();
      },
      converter: const StringToSurfacePointCollectionConverter());
  }

  @override createPrimitive(){
    rawElement = new SVGElement.tag('polyline');
    rawElement.style.setProperty('fill', 'none');
  }

  String _pointsToString(){
    if (points.value == null || points.value.isEmpty) return '';
    final sb = new StringBuffer();

    points.value.forEach((p) => sb.add('${p.x},${p.y} '));
    return sb.toString().trim();
  }
}

class StringToSurfacePointCollectionConverter implements ValueConverter
{
  const StringToSurfacePointCollectionConverter();

  convert(value, {parameter}){
    if (value is! String) return value;

    return value
            .split(' ')
            .map((ps){
              final p = ps.split(',');
              assert(p.length == 2);
              return new SurfacePoint(double.parse(p[0]), double.parse(p[1]));
            });
  }
}
