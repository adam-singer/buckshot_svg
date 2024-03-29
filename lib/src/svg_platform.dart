part of buckshot_svg;

class SvgPlatform extends SurfacePlatform
{
  static const int _UNKNOWN = -1;
  static const int _HTML_ELEMENT = 0;
  static const int _HTTP_RESOURCE = 1;
  static const int _SERIALIZED = 2;
  bool _resourcesLoaded = false;
  final Expando<SvgPlatformElement> surfaceElement =
      new Expando<SvgPlatformElement>();
  SVGSVGElement _rootElement;

  /** Initializes the HtmlPlatform with the default host ID '#BuckshotHost'. */
  factory SvgPlatform() => new SvgPlatform._internal('#BuckshotHost');

  /**
   * Initializes thte HtmlPlatform using the given [hostID] which must begin
   * with a '#'.
   */
  factory SvgPlatform.host(String hostID) => new SvgPlatform._internal(hostID);

  SvgPlatform._internal(String hostID){
    assert(hostID != null);
    assert(hostID.startsWith('#'));
    _rootElement = query(hostID);

    if (_rootElement == null){
      throw "Unable to initialize the HtmlSurface provider. "
        "Div with ID 'BuckshotHost' not found in HTML page.";
    }

    _setMutationObserver(_rootElement);
    _startEventLoop();
  }

  @override String get namespace => 'http://buckshotui.org/surface/svg';

  /**
   * Retrieves a buckshot template from the given [uri].  This function also
   * supports a uri of '#name', which will query for the template in the HTML
   * DOM.
   */
  @override Future<String> getTemplate(String uri){
    var c = new Completer();
    final type = _determineType(uri);

    if (type == _HTML_ELEMENT) {
      // e.g. "#something"
      var result = document.query(uri);
      if (result == null) {
        throw new BuckshotException('Unabled to find template'
            ' "${uri}" in HTML file.');
      }
      c.complete(result.text.trim());
    }else if (type == _HTTP_RESOURCE){
      // e.g. "path/to/myTemplate.xml"
      var r = new HttpRequest();

      void onError(e) {
        c.complete(null);
      }

      r.on.abort.add(onError);
      r.on.error.add(onError);
      r.on.loadEnd.add((e) {
        c.complete(r.responseText.trim());
      });

      try{
        r.open('GET', uri, true);
        r.setRequestHeader('Accept', 'text/xml');
        r.send();
      }on Exception catch(e){
        c.complete(null);
      }
    }else{
      // should be a template.
      c.complete(uri);
    }

    return c.future;
  }

  /**
   * Renders the given [view] into a host [Border] container, which is
   * implicitly created in the DOM host element.
   */
  @override Future<PlatformElement> render(View view){
    return initFramework()
            .chain((_) => view.ready)
            .chain((rootVisual){
              _rootElement.elements.clear();
              _rootElement.elements.add(rootVisual.rawElement);
              return new Future.immediate(rootVisual);
            });
  }

  /** Initializes the given [element] to the [Presenter]. */
  @override void initElement(PlatformElement element){
    if (element is! SvgPlatformElement) return;
    surfaceElement[element.rawElement] = element;
  }

  void _startEventLoop(){
    workers = new HashMap<String, EventLoopCallback>();
    window.requestAnimationFrame(_doEventLoopWork);
  }

  void _doEventLoopWork(num time){
    workers.forEach((_, work) => work(time));
    window.requestAnimationFrame(_doEventLoopWork);
  }

  void _setMutationObserver(Element element){
    new MutationObserver(_mutationHandler)
      .observe(element, subtree: true, childList: true, attributes: false);
  }

  // Provides a reliable loaded/unloaded notification for all elements in
  // the visual tree.
  void _mutationHandler(List<MutationRecord> mutations,
                        MutationObserver observer){
    for (final MutationRecord r in mutations){
      r.addedNodes.forEach((node){
        if (surfaceElement[node] == null) return;
        final el = surfaceElement[node];
        if (el.isLoaded) return;
        el.onLoaded();

        if (el is FrameworkContainer){
          _loadChildren(el);
        }
      });

      r.removedNodes.forEach((node){
        if (surfaceElement[node] == null) return;
        final el = surfaceElement[node];
        if (!el.isLoaded) return;
        el.onUnloaded();

        if (el is FrameworkContainer){
          _unloadChildren(el);
        }
      });
    }
  }

  void _unloadChildren(FrameworkContainer container){
    if (container.containerContent == null) return;

    if (container.containerContent is Collection){
      container.containerContent.forEach((content){
        assert(content is SurfaceElement);
        content.onUnloaded();

        if (content is FrameworkContainer){
          _unloadChildren(content);
        }
      });
    }else if (container.containerContent is SurfaceElement){
      container.containerContent.onUnloaded();
      if (container.containerContent is FrameworkContainer){
        _unloadChildren(container.containerContent);
      }
    }else if (container.containerContent is String){
      // do nothing
    }else{
      new Logger('buckshot.pal.html')
      ..warning('Invalid container type found: $container'
          ' ${container.containerContent}');
    }
  }

  void _loadChildren(FrameworkContainer container){
    if (container.containerContent == null) return;

    if (container.containerContent is Collection){
      container.containerContent.forEach((content){
        if(content is! SurfaceElement) {
          // likely a text node of a textblock.
          assert(content is String);
          return;
        }
        content.onLoaded();

        if (content is FrameworkContainer){
          _loadChildren(content);
        }
      });
    }else if (container.containerContent is SurfaceElement){
      container.containerContent.onLoaded();
      if (container.containerContent is FrameworkContainer){
        _loadChildren(container.containerContent);
      }
    }else if (container.containerContent is String){
      // do nothing
    }else{
      new Logger('buckshot.pal.html')
        ..warning('Invalid container type found: $container'
            ' ${container.containerContent}');
    }
  }

  /**
  * Used to determine the type of the string.
  *
  * Checks to see if its referencing a [_HTML_ELEMENT], a [_HTTP_RESOURCE]
  * or one of the serialized types [_SERIALIZED].
  */
  static int _determineType(String from) {
    if (from.startsWith('#')) {
      return _HTML_ELEMENT;
    }else{
      final t = new Template();

      for(final p in t.providers){
        if(p.isFormat(from)){
          return _SERIALIZED;
        }
      }
    }

    // Assume its pointing to a HTTP resource
    return _HTTP_RESOURCE;
  }

  Future _loadResources(){
    if (_resourcesLoaded) return new Future.immediate(false);
    _resourcesLoaded = true;

    if (!document.body.attributes.containsKey('data-buckshot-resources')){
      return new Future.immediate(false);
    }

    return Template
        .deserialize(document.body.attributes['data-buckshot-resources']);
  }
}
