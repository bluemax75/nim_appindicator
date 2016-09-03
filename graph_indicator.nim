import gtk2, glib2
import cairo
import appindicator

## Create a graph from a sequence of numbers from 0 to 1, using Cairo
## Initialy use a svg surface to be used on an appindicator


proc doPercentageBars(cr: PContext, width,height: int, data: openarray[float]) =
  ## Adds Bars corresponding to the sequence of percentage values
  
  # TODO how to get surface size (width and height)
  # let
  #     width = cr.get_target().get_width()
  #     height = cr.get_target.get_height
  cr.set_source_rgba(0.0, 0.0, 0.0, 1.0)
  cr.rectangle(0, 0, width.float, height.float)
  cr.fill()

  cr.set_source_rgba(0.9, 0.0, 0.0, 1.0)
  var x = 0.0

  echo "Begin ", repr(data), " ", width, " ", height
  cr.move_to(0.0, height.float)
  if data.len < width:
    cr.line_to(width.float - data.len.float, height.float) 
    x = width.float - data.len.float
    echo "line to", x
  for y in data:
    x += 1
    cr.move_to(x, height.float)
    cr.line_to(x, height.float * (1-y))
    echo "x=",x, " y=", height.float * y
  cr.stroke

proc graphImage(fname: string, width,height: int, data: openarray[float]) =
  var 
    surf = svg_surface_create(fname, width.float, height.float)
    cr = create(surf)

  cr.doPercentageBars(width, height, data)

  surf.finish
  cr.destroy
  surf.destroy


when isMainModule:
  const 
    width = 40
    height = 20

  nim_init()
  graphImage("hola.svg", width, height, [0.2, 0, 0.4, 0.5, 0.7, 0.1, 0.1, 0.1, 0.9])
  var
    appind = app_indicator_new("appindtest", "hola.svg", APP_INDICATOR_CATEGORY_SYSTEM_SERVICES)

  appind.set_status(APP_INDICATOR_STATUS_ACTIVE)
  appind.set_menu(menu_new())
  main()

