#!/usr/bin/env python3
#
# Fibonacci spiral layout for river, implemented in simple python. Reading this
# code should help you get a basic understanding of how to use river-layout to
# create a basic layout generator.
#
# This depends on pywayland: https://github.com/flacjacket/pywayland/
#
# Q: Wow, this looks complicated!
# A: For simple layouts, you really only need to care about what's in the
#    layout_handle_layout_demand() function. And the rest isn't as complicated
#    as it looks.

import sys
from pywayland.client import Display
from pywayland.protocol.wayland import WlOutput
try:
    from pywayland.protocol.river_layout_v3 import RiverLayoutManagerV3
except ModuleNotFoundError:
    river_layout_help = """
    Your pywayland package does not have bindings for river-layout-v3.
    You can generate the bindings with the following command:
         python3 -m pywayland.scanner -i /usr/share/wayland/wayland.xml river-layout-v3.xml
    It is recommended to use a virtual environment to avoid modifying your
    system-wide python installation, See: https://docs.python.org/3/library/venv.html
    """
    print(river_layout_help)
    quit()

layout_manager = None
outputs = []
loop = True


def layout_push_view_dimensions_with_flip(
        layout,
        x, y, w, h,
        serial,
        usable_w, usable_h,
        do_swap_xy, do_flip_axis,
):
    if do_swap_xy:
        y, x, h, w = x, y, w, h

    flip_x = False
    flip_y = False
    if do_swap_xy:
        if do_flip_axis[0]:
            flip_x = True
        if do_flip_axis[1]:
            flip_y = True
    else:
        if do_flip_axis[0]:
            flip_y = True
        if do_flip_axis[1]:
            flip_x = True

    if flip_x:
        x = usable_w - (x + w)
    if flip_y:
        y = usable_h - (y + h)

    layout.push_view_dimensions(x, y, w, h, serial)


def layout_handle_layout_demand_spiral(layout, view_count, usable_w, usable_h, tags, serial):

    x = 0
    y = 0
    do_swap_xy = layout.user_data.do_swap_xy
    do_flip_axis = layout.user_data.do_flip_axis
    axis_depth = layout.user_data.axis_depth[do_swap_xy]

    if do_swap_xy:
        w = usable_h
        h = usable_w
    else:
        w = usable_w
        h = usable_h

    for i in range(0, view_count - 1):
        if (axis_depth != -1) and (i >= axis_depth):
            if axis_depth % 2:
                w //= 2
                x_final, y_final = x, y
                x += w
            else:
                h //= 2
                x_final, y_final = x, y
                y += h
        else:
            if i % 2:
                w //= 2
                if (i % 4) == 2:
                    x_final, y_final = x + w, y
                else:
                    x_final, y_final = x, y
                    x += w
            else:
                h //= 2
                if (i % 4) == 3:
                    x_final, y_final = x, y + h
                else:
                    x_final, y_final = x, y
                    y += h

        layout_push_view_dimensions_with_flip(layout, x_final, y_final, w, h, serial,
                                              usable_w, usable_h,
                                              do_swap_xy, do_flip_axis)
        x_final, y_final = x, y

    x_final, y_final = x, y
    layout_push_view_dimensions_with_flip(layout, x_final, y_final, w, h, serial,
                                          usable_w, usable_h,
                                          do_swap_xy, do_flip_axis)
    # Committing the layout means telling the server that your code is done
    # laying out windows. Make sure you have pushed exactly the right amount of
    # view dimensions, a mismatch is a fatal protocol error.
    #
    # You also have to provide a layout name. This is a user facing string that
    # the server can forward to status bars. You can use it to tell the user
    # which layout is currently in use. You could also add some status
    # information status information about your layout, which is what we do here.
    layout.commit(f"{view_count} windows laid out by python", serial)


def layout_handle_layout_demand_single(layout, view_count, usable_w, usable_h, tags, serial):
    x = 0
    y = 0
    w = usable_w
    h = usable_h
    for i in range(0, view_count - 1):
        h //= 2
        if i % 4 == 3:
            layout.push_view_dimensions(x, y + h, w, h, serial)
        else:
            layout.push_view_dimensions(x, y, w, h, serial)
            y += h
    layout.push_view_dimensions(x, y, w, h, serial)
    layout.commit(f"{view_count} windows laid out by python", serial)


def layout_handle_user_command_spiral(layout, command):
    command = command.split()
    if not command:
        sys.stderr.write("No arguments given, aborting!")
        return

    if command[0] == "main-location":
        if len(command) != 2:
            sys.stderr.write("No arguments given, aborting!")
            return

        do_swap_xy_prev = layout.user_data.do_swap_xy
        do_flip_axis_prev = layout.user_data.do_flip_axis[:]

        if command[1] == "left":
            layout.user_data.do_swap_xy = True
            layout.user_data.do_flip_axis[0] = False
        elif command[1] == "right":
            layout.user_data.do_swap_xy = True
            layout.user_data.do_flip_axis[0] = True
        elif command[1] == "top":
            layout.user_data.do_swap_xy = False
            layout.user_data.do_flip_axis[0] = False
        elif command[1] == "bottom":
            layout.user_data.do_swap_xy = False
            layout.user_data.do_flip_axis[0] = True
        else:
            sys.stderr.write("Unknown location %r (expected on of left/right/top/bottom)!" % command[1])
            return

        if (
                (do_swap_xy_prev == layout.user_data.do_swap_xy) and
                (do_flip_axis_prev[0] == layout.user_data.do_flip_axis[0])
        ):
            # The same axis was attempted, flip the secondary axis (as there isn't a nice way to control this).
            layout.user_data.do_flip_axis[1] = not layout.user_data.do_flip_axis[1]
        elif do_swap_xy_prev != layout.user_data.do_swap_xy:
            # Always reset when switching axis, this allows the flipping to be kept when
            # changing on the same axis (which is nicer and less surprising).
            layout.user_data.do_flip_axis[1] = False

    elif command[0] == "axis-depth-x":
        if len(command) != 2:
            sys.stderr.write("No arguments given, aborting!")
            return
        layout.user_data.axis_depth[0] = int(command[1])

    elif command[0] == "axis-depth-y":
        if len(command) != 2:
            sys.stderr.write("No arguments given, aborting!")
            return
        layout.user_data.axis_depth[1] = int(command[1])


def layout_handle_namespace_in_use(layout):
    # Oh no, the namespace we choose is already used by another client! All we
    # can do now is destroy the layout object. Because we are lazy, we just
    # abort and let our cleanup mechanism destroy it. A more sophisticated
    # client could instead destroy only the one single affected layout object
    # and recover from this mishap. Writing such a client is left as an exercise
    # for the reader.
    print("Namespace already in use!")
    global loop
    loop = False


class Output:
    __slots__ = (
        "output",
        "layouts",
        "id",
        "do_swap_xy",
        "do_flip_axis",
        "axis_depth",
    )

    def __init__(self):
        self.output = None
        self.layouts = []
        self.id = None

        self.do_swap_xy = True
        self.do_flip_axis = [False, False]
        # Support a different depth depending on `do_swap_xy`.
        self.axis_depth = [2, 1]

    def destroy(self):
        if self.layout:
            for layout in self.layouts:
                layout.destroy()
        if self.output is not None:
            self.output.destroy()

    def configure(self):
        global layout_manager
        if not self.layouts and layout_manager is not None:
            # We need to set a namespace, which is used to identify our layout.

            layout = layout_manager.get_layout(self.output, "spiral")
            layout.user_data = self
            layout.dispatcher["layout_demand"] = layout_handle_layout_demand_spiral
            layout.dispatcher["user_command"] = layout_handle_user_command_spiral
            layout.dispatcher["namespace_in_use"] = layout_handle_namespace_in_use
            self.layouts.append(layout)

            layout = layout_manager.get_layout(self.output, "binary_y")
            layout.user_data = self
            layout.dispatcher["layout_demand"] = layout_handle_layout_demand_single
            # layout.dispatcher["user_command"] = layout_handle_user_command
            layout.dispatcher["namespace_in_use"] = layout_handle_namespace_in_use
            self.layouts.append(layout)


def registry_handle_global(registry, id, interface, version):
    global layout_manager
    global output
    if interface == 'river_layout_manager_v3':
        layout_manager = registry.bind(id, RiverLayoutManagerV3, version)
    elif interface == 'wl_output':
        output = Output()
        output.output = registry.bind(id, WlOutput, version)
        output.id = id
        output.configure()
        outputs.append(output)


def registry_handle_global_remove(registry, id):
    for output in outputs:
        if output.id == id:
            output.destroy()
            outputs.remove(output)


display = Display()
display.connect()

registry = display.get_registry()
registry.dispatcher["global"] = registry_handle_global
registry.dispatcher["global_remove"] = registry_handle_global_remove

display.dispatch(block=True)
display.roundtrip()

if layout_manager is None:
    print("No layout_manager, aborting")
    quit()

for output in outputs:
    output.configure()

while loop and display.dispatch(block=True) != -1:
    pass

# Destroy outputs
for output in outputs:
    output.destroy()
    outputs.remove(output)

display.disconnect()
