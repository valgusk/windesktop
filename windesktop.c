#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/Xatom.h>
#include <stdlib.h>
#include <stdio.h>

int main (int argc, char **argv)
{
    Display	    *dpy;
    dpy = XOpenDisplay (NULL);
    Window focusTo = 0;

    if (!dpy)
    {
        fprintf (stderr, "%s: Error: couldn't open display\n", argv[0]);
        return 1;
    }

    if (argc < 2)
    {
        fprintf (stderr, "Error: requires window id integer as argument\n");
        return 1;
    }

    if (argc == 3)
    {
        focusTo = strtol(argv[2], NULL, 0);
    }

    Window win;
    win = strtol(argv[1], NULL, 0);

    Atom        state[256];
    int         nState = 0;
    Atom        type;

    state[nState++] = XInternAtom (dpy, "_NET_WM_STATE_FULLSCREEN", 0);
    state[nState++] = XInternAtom (dpy, "_NET_WM_STATE_SKIP_TASKBAR", 0);
    state[nState++] = XInternAtom (dpy, "_NET_WM_STATE_SKIP_PAGER", 0);
    state[nState++] = XInternAtom (dpy, "_NET_WM_STATE_BELOW", 0);
    state[nState++] = XInternAtom (dpy, "_COMPIZ_WALLPAPER_SUPPORTED", 0);

    XUnmapWindow (dpy, win);
    if (nState)
        XChangeProperty (dpy, win, XInternAtom (dpy, "_NET_WM_STATE", 0),
                XA_ATOM, 32, PropModeReplace,
                (unsigned char *) state, nState);


    type = XInternAtom (dpy, "_NET_WM_WINDOW_TYPE_DESKTOP", 0);


    XChangeProperty (dpy, win, XInternAtom (dpy, "_NET_WM_WINDOW_TYPE", 1),
                    XA_ATOM, 32, PropModeReplace,
                    (unsigned char *) &type, 1);
    
    XMapWindow (dpy, win);
    XLowerWindow(dpy, win);

    if(focusTo != 0){
        XUnmapWindow (dpy, focusTo);
        XMapWindow (dpy, focusTo);
    } else {
        XSetInputFocus(dpy, PointerRoot, RevertToNone, CurrentTime);
    }

    XCloseDisplay (dpy);

    return 0;
}
