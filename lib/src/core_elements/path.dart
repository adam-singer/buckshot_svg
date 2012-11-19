part of buckshot_svg;

class Path extends Shape
{
  FrameworkProperty<String> data;

  Path.register() : super.register();
  Path();
  @override makeMe() => new Path();


  @override void initProperties(){
    super.initProperties();

    data = new FrameworkProperty(this, 'data',
        propertyChangedCallback: (String value){
          rawElement.attributes['d'] = value;
        });
  }

  void invalidate(){

  }

  @override void createPrimitive(){
    rawElement = new SVGElement.tag('path');
    rawElement.style.setProperty('fill', 'none');
  }
}

//TODO provide programmatic API for building paths
class PathInstruction
{

}

class MoveTo extends PathInstruction
{

}

class LineTo extends PathInstruction
{

}

class HorizontalLineTo extends PathInstruction
{

}

class VerticalLineTo extends PathInstruction
{

}

class CurveTo extends PathInstruction
{

}

class SmoothCurveTo extends PathInstruction
{

}

class QuadraticBezierCurve extends PathInstruction
{

}

class SmoothQuadraticBezierCurveTo extends PathInstruction
{

}

class EllipticalArc extends PathInstruction
{

}

class ClosePath extends PathInstruction
{

}