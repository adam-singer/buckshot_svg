import 'package:buckshot_svg/buckshot_svg_browser.dart';
import 'dart:html';

main(){
  initPlatform();
  svgPlatform.render(new View.fromTemplate(template));
}

String template =
r'''
<group>
  <rect x='10' y='10' width='100' height='50' fill='Blue' stroke='Black' strokewidth='3' />
  <ellipse opacity='.75' cx='75' cy='75' rx='50' ry='100' fill='Orange' stroke='Black' strokewidth='5' />
  <image uri='web/resources/buckshot_logo.png' x='300' y='10' width='200' height='200' />
  <line x1='15' y1='15' x2='200' y2='200' stroke='Green' strokewidth='5' />
  <polyline points="0,40 40,40 40,80 80,80 80,120 120,120 120,160" stroke='Red' strokewidth='5' />
  <polygon cursor='Help' points="350,75 379,161 469,161 397,215 423,301 350,250 277,301 303,215 231,161 321,161" stroke='Black' strokewidth='1' fill='Lime' />
</group>
''';