part of buckshot_svg;

class Shape extends SvgPlatformElement
{
  FrameworkProperty<SolidColorBrush> fill;
  FrameworkProperty<Color> stroke;
  FrameworkProperty<num> strokeWidth;

  Shape.register() : super.register();
  Shape();
  @override makeMe() => null;

  @override initProperties(){
    super.initProperties();

    fill = new FrameworkProperty(this, 'fill',
      propertyChangedCallback: (SolidColorBrush brush){
        rawElement.style.setProperty('fill', '${brush.color.value.toColorString()}');
      },
      converter: const StringToSolidColorBrushConverter());

    stroke = new FrameworkProperty(this, 'stroke',
      propertyChangedCallback: (Color color){
        rawElement.style.setProperty('stroke', '${color.toColorString()}');
      },
      converter: const StringToColorConverter());

    strokeWidth = new FrameworkProperty(this, 'strokeWidth',
        propertyChangedCallback: (num value){
          rawElement.style.setProperty('stroke-width', '${value}px');
        },
        converter: const StringToNumericConverter());

  }

  static void setFillBrush(SvgPlatformElement element, Brush brush){
    final rawElement = element.rawElement;

    if (brush is SolidColorBrush){
      rawElement.style.setProperty('fill', brush.color.value.toColorString());
    }else if (brush is LinearGradientBrush){
      rawElement.style.setProperty('fill',
          brush.fallbackColor.value.toColorString());
      return;
      //TODO: implement SVG gradient resource
      final colorString = new StringBuffer();

      //create the string of stop colors
      brush.stops.value.forEach((GradientStop stop){
        colorString.add(stop.color.value.toColorString());

        if (stop.percent.value != -1) {
          colorString.add(" ${stop.percent.value}%");
        }

        if (stop != brush.stops.value.last) {
          colorString.add(", ");
        }
      });

      //set the background for all browser types
      rawElement.style.background =
          "-webkit-linear-gradient(${brush.direction.value}, ${colorString})";
          rawElement.style.background =
              "-moz-linear-gradient(${brush.direction.value}, ${colorString})";
              rawElement.style.background =
                  "-ms-linear-gradient(${brush.direction.value}, ${colorString})";
                  rawElement.style.background =
                      "-o-linear-gradient(${brush.direction.value}, ${colorString})";
                      rawElement.style.background =
                          "linear-gradient(${brush.direction.value}, ${colorString})";
    }else if (brush is RadialGradientBrush){
      //set the fallback
      rawElement.style.background = brush.fallbackColor.value.toColorString();
      return;
      //TODO implement svg gradient resource
      final colorString = new StringBuffer();

      //create the string of stop colors
      brush.stops.value.forEach((GradientStop stop){
        colorString.add(stop.color.value.toColorString());

        if (stop.percent.value != -1) {
          colorString.add(" ${stop.percent.value}%");
        }

        if (stop != brush.stops.value.last) {
          colorString.add(", ");
        }
      });

      //set the background for all browser types
      rawElement.style.background =
          "-webkit-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
          rawElement.style.background =
              "-moz-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
              rawElement.style.background =
                  "-ms-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
                  rawElement.style.background =
                      "-o-radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
                      rawElement.style.background =
                          "radial-gradient(50% 50%, ${brush.drawMode.value}, ${colorString})";
    }else{
      new Logger('buckshot.pal.html.HtmlPlatformElement')
        ..warning('Unrecognized brush "$brush" assignment. Default to White.');
      rawElement.style.background =
          new SolidColorBrush.fromPredefined(Colors.White);
    }
  }
}
