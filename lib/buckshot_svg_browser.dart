library buckshot_svg;

import 'dart:svg';
import 'dart:html';
import 'package:buckshot/pal/surface_platform/surface_platform.dart';
export 'package:buckshot/pal/surface_platform/surface_platform.dart';

part 'src/svg_platform.dart';
part 'src/svg_platform_element.dart';
part 'src/core_elements/ellipse.dart';
part 'src/core_elements/path.dart';
part 'src/core_elements/rect.dart';
part 'src/core_elements/text.dart';
part 'src/core_elements/image.dart';
part 'src/core_elements/shape.dart';
part 'src/core_elements/group.dart';
part 'src/core_elements/line.dart';
part 'src/core_elements/polyline.dart';
part 'src/core_elements/polygon.dart';

bool _platformInitialized = false;

/**
 * Initializes the Buckshot framework to use the [HtmlPlatform] presenter.
 *
 * Optional argument [hostID] may also be specified (e.g. '#myhostdiv')
 *
 * IMPORTANT:  This should be called first before making any other calls
 * to the Buckshot API.
 */
void initPlatform({String hostID : '#BuckshotHost'}){
  if (_platformInitialized) return;
  _svgPlatform = new SvgPlatform.host(hostID);
  registerElement(new Group.register());
  registerElement(new Ellipse.register());
  registerElement(new Rect.register());
  registerElement(new Image.register());
  registerElement(new Line.register());
  registerElement(new PolyLine.register());
  registerElement(new Polygon.register());
  registerElement(new Path.register());
  svgPlatform._loadResources();
  _platformInitialized = true;
}

/**
 * Gets the [HtmlPlatform] context for this [Platform].
 */
SvgPlatform get svgPlatform => platform as SvgPlatform;
set _svgPlatform(SvgPlatform p) {
  assert(platform == null);
  platform = p;
}