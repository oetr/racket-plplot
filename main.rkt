#lang racket

(require ffi/unsafe
         ffi/unsafe/define
         racket/provide)

(define-syntax define+provide
  (syntax-rules ()
    [(_ (name args ... . rest) body ...)
     (begin (provide name)
            (define (name args ... . rest)
              body ...))]
    [(_ (name args ...) body ...)
     (begin (provide name)
            (define (name args ...)
              body ...))]
    [(_ name body)
     (begin
       (provide name)
       (define name body))]))


(define plplot-lib (ffi-lib "libplplot"))

(define-ffi-definer define-ffi-lib-internal plplot-lib)

(define-syntax define-ffi+provide
  (syntax-rules ()
    [(_ name body)
     (begin
       (provide name)
       (define-ffi-lib-internal name body))]))


(define+provide PLFLT   _double*)
(define+provide PLUINT  _uint32)
(define+provide PLINT   _int32)
(define+provide PLINT64 _int64)
(define+provide PLUNICODE PLUINT)
(define+provide PLBOOL  PLINT)
(define+provide PLPointer _pointer)
(define+provide PLFLT_NC_FE_POINTER _pointer)
(define+provide PLFLT_FE_POINTER _pointer)


;; Pointers to mutable scalars:
(define+provide PLINT_NC_SCALAR _pointer)
(define+provide PLBOOL_NC_SCALAR _pointer)
(define+provide PLUNICODE_NC_SCALAR _pointer)
(define+provide PLCHAR_NC_SCALAR _pointer)
(define+provide PLFLT_NC_SCALAR _pointer)

;; Pointers to mutable vectors:
(define+provide PLINT_NC_VECTOR _pointer)
(define+provide PLCHAR_NC_VECTOR _pointer)
(define+provide PLFLT_NC_VECTOR _pointer)

;; Pointers to immutable vectors:
(define+provide PLINT_VECTOR _pointer)
(define+provide PLBOOL_VECTOR _pointer)
(define+provide PLCHAR_VECTOR _string)
(define+provide PLFLT_VECTOR _pointer)

;; Pointers to mutable 2-dimensional matrices:
(define+provide PLCHAR_NC_MATRIX _pointer)
(define+provide PLFLT_NC_MATRIX _pointer)

;; Pointers to immutable 2-dimensional matrices,
;; (i.e., pointers to const pointers to const values):
(define+provide PLCHAR_MATRIX _pointer)
(define+provide PLFLT_MATRIX _pointer)


(define+provide *PLMAPFORM_callback (_fun PLINT PLFLT_NC_VECTOR PLFLT_NC_VECTOR -> _void))
(define+provide *PLTRANSFORM_callback (_fun PLFLT PLFLT PLFLT_NC_SCALAR PLFLT_NC_SCALAR PLPointer -> _void))
(define+provide *PLLABEL_FUNC_callback (_fun PLINT PLFLT PLCHAR_NC_VECTOR PLINT PLPointer -> _void))
(define+provide *PLF2EVAL_callback (_fun PLINT PLINT PLPointer -> PLFLT))
(define+provide *PLFILL_callback (_fun PLINT PLFLT_VECTOR PLFLT_VECTOR -> _void))
(define+provide *PLDEFINED_callback (_fun PLFLT PLFLT -> PLINT))


;;--------------------------------------------------------------------------
;; Complex data types and other good stuff
;;--------------------------------------------------------------------------

;; Switches for escape function call.
;; Some of these are obsolete but are retained in order to process
;; old metafiles
(define+provide PLESC_SET_RGB                   1)  ;; obsolete
(define+provide PLESC_ALLOC_NCOL                2)  ;; obsolete
(define+provide PLESC_SET_LPB                   3)  ;; obsolete
(define+provide PLESC_EXPOSE                    4)  ;; handle window expose
(define+provide PLESC_RESIZE                    5)  ;; handle window resize
(define+provide PLESC_REDRAW                    6)  ;; handle window redraw
(define+provide PLESC_TEXT                      7)  ;; switch to text screen
(define+provide PLESC_GRAPH                     8)  ;; switch to graphics screen
(define+provide PLESC_FILL                      9)  ;; fill polygon
(define+provide PLESC_DI                        10) ;; handle DI command
(define+provide PLESC_FLUSH                     11) ;; flush output
(define+provide PLESC_EH                        12) ;; handle Window events
(define+provide PLESC_GETC                      13) ;; get cursor position
(define+provide PLESC_SWIN                      14) ;; set window parameters
(define+provide PLESC_DOUBLEBUFFERING           15) ;; configure double buffering
(define+provide PLESC_XORMOD                    16) ;; set xor mode
(define+provide PLESC_SET_COMPRESSION           17) ;; AFR: set compression
(define+provide PLESC_CLEAR                     18) ;; RL: clear graphics region
(define+provide PLESC_DASH                      19) ;; RL: draw dashed line
(define+provide PLESC_HAS_TEXT                  20) ;; driver draws text
(define+provide PLESC_IMAGE                     21) ;; handle image
(define+provide PLESC_IMAGEOPS                  22) ;; plimage related operations
(define+provide PLESC_PL2DEVCOL                 23) ;; convert PLColor to device color
(define+provide PLESC_DEV2PLCOL                 24) ;; convert device color to PLColor
(define+provide PLESC_SETBGFG                   25) ;; set BG, FG colors
(define+provide PLESC_DEVINIT                   26) ;; alternate device initialization
(define+provide PLESC_GETBACKEND                27) ;; get used backend of (wxWidgets) driver - no longer used
(define+provide PLESC_BEGIN_TEXT                28) ;; get ready to draw a line of text
(define+provide PLESC_TEXT_CHAR                 29) ;; render a character of text
(define+provide PLESC_CONTROL_CHAR              30) ;; handle a text control character (super/subscript, etc.)
(define+provide PLESC_END_TEXT                  31) ;; finish a drawing a line of text
(define+provide PLESC_START_RASTERIZE           32) ;; start rasterized rendering
(define+provide PLESC_END_RASTERIZE             33) ;; end rasterized rendering
(define+provide PLESC_ARC                       34) ;; render an arc
(define+provide PLESC_GRADIENT                  35) ;; render a gradient
(define+provide PLESC_MODESET                   36) ;; set drawing mode
(define+provide PLESC_MODEGET                   37) ;; get drawing mode
(define+provide PLESC_FIXASPECT                 38) ;; set or unset fixing the aspect ratio of the plot
(define+provide PLESC_IMPORT_BUFFER             39) ;; set the contents of the buffer to a specified byte string
(define+provide PLESC_APPEND_BUFFER             40) ;; append the given byte string to the buffer
(define+provide PLESC_FLUSH_REMAINING_BUFFER    41) ;; flush the remaining buffer e.g. after new data was appended

;; Alternative unicode text handling control characters
(define+provide PLTEXT_FONTCHANGE               0) ;; font change in the text stream
(define+provide PLTEXT_SUPERSCRIPT              1) ;; superscript in the text stream
(define+provide PLTEXT_SUBSCRIPT                2) ;; subscript in the text stream
(define+provide PLTEXT_BACKCHAR                 3) ;; back-char in the text stream
(define+provide PLTEXT_OVERLINE                 4) ;; toggle overline in the text stream
(define+provide PLTEXT_UNDERLINE                5) ;; toggle underline in the text stream

;; image operations
(define+provide ZEROW2B                         1)
(define+provide ZEROW2D                         2)
(define+provide ONEW2B                          3)
(define+provide ONEW2D                          4)

;; Window parameter tags

(define+provide PLSWIN_DEVICE    1)              ;; device coordinates
(define+provide PLSWIN_WORLD     2)              ;; world coordinates

;; Axis label tags
(define+provide PL_X_AXIS        1)              ;; The x-axis
(define+provide PL_Y_AXIS        2)              ;; The y-axis
(define+provide PL_Z_AXIS        3)              ;; The z-axis

;; PLplot Option table & support constants

;; Option-specific settings

(define+provide PL_OPT_ENABLED      #x0001)      ;; Obsolete
(define+provide PL_OPT_ARG          #x0002)      ;; Option has an argument
(define+provide PL_OPT_NODELETE     #x0004)      ;; Don't delete after processing
(define+provide PL_OPT_INVISIBLE    #x0008)      ;; Make invisible
(define+provide PL_OPT_DISABLED     #x0010)      ;; Processing is disabled

;; Option-processing settings -- mutually exclusive

(define+provide PL_OPT_FUNC      #x0100)         ;; Call handler function
(define+provide PL_OPT_BOOL      #x0200)         ;; Set *var = 1
(define+provide PL_OPT_INT       #x0400)         ;; Set *var = atoi(optarg)
(define+provide PL_OPT_FLOAT     #x0800)         ;; Set *var = atof(optarg)
(define+provide PL_OPT_STRING    #x1000)         ;; Set var = optarg

;; Global mode settings
;; These override per-option settings

(define+provide PL_PARSE_PARTIAL              #x0000) ;; For backward compatibility
(define+provide PL_PARSE_FULL                 #x0001) ;; Process fully & exit if error
(define+provide PL_PARSE_QUIET                #x0002) ;; Don't issue messages
(define+provide PL_PARSE_NODELETE             #x0004) ;; Don't delete options after
;; processing
(define+provide PL_PARSE_SHOWALL              #x0008) ;; Show invisible options
(define+provide PL_PARSE_OVERRIDE             #x0010) ;; Obsolete
(define+provide PL_PARSE_NOPROGRAM            #x0020) ;; Program name NOT in *argv[0]..
(define+provide PL_PARSE_NODASH               #x0040) ;; Set if leading dash NOT required
(define+provide PL_PARSE_SKIP                 #x0080) ;; Skip over unrecognized args

;; FCI (font characterization integer) related constants.
(define+provide PL_FCI_MARK                   #x80000000)
(define+provide PL_FCI_IMPOSSIBLE             #x00000000)
(define+provide PL_FCI_HEXDIGIT_MASK          #xf)
(define+provide PL_FCI_HEXPOWER_MASK          #x7)
(define+provide PL_FCI_HEXPOWER_IMPOSSIBLE    #xf)
;; These define+provide hexpower values corresponding to each font attribute.
(define+provide PL_FCI_FAMILY                 #x0)
(define+provide PL_FCI_STYLE                  #x1)
(define+provide PL_FCI_WEIGHT                 #x2)
;; These are legal values for font family attribute
(define+provide PL_FCI_SANS                   #x0)
(define+provide PL_FCI_SERIF                  #x1)
(define+provide PL_FCI_MONO                   #x2)
(define+provide PL_FCI_SCRIPT                 #x3)
(define+provide PL_FCI_SYMBOL                 #x4)
;; These are legal values for font style attribute
(define+provide PL_FCI_UPRIGHT                #x0)
(define+provide PL_FCI_ITALIC                 #x1)
(define+provide PL_FCI_OBLIQUE                #x2)
;; These are legal values for font weight attribute
(define+provide PL_FCI_MEDIUM                 #x0)
(define+provide PL_FCI_BOLD                   #x1)


;; Option table definition
(define-cstruct _PLOptionTable
  ([opt PLCHAR_VECTOR] 
   [handler (_fun PLCHAR_VECTOR PLCHAR_VECTOR PLPointer -> _int)]
   [client_data PLPointer]
   [var PLPointer]
   [mode _long]
   [syntax PLCHAR_VECTOR]
   [desc PLCHAR_VECTOR]))

(provide (matching-identifiers-out #rx".*PLOptionTable.*$" (all-defined-out)))

;; PLplot Graphics Input structure

(define+provide PL_MAXKEY    16)

;;Masks for use with PLGraphicsIn::state
;;These exactly coincide with the X11 masks
;;from X11/X.h, however the values 1<<3 to
;;1<<7 aparently may vary depending upon
;;X implementation and keyboard
;; Numerical (defines are parsed further to help determine
;; additional files such as ../bindings/swig-support/plplotcapi.i
;; so must (define+providenumerical (defines with numbers rather than C operators
;; such as <<.
(define+provide PL_MASK_SHIFT      #x1)    ;; (1 << 0)
(define+provide PL_MASK_CAPS       #x2)    ;; (1 << 1)
(define+provide PL_MASK_CONTROL    #x4)    ;; (1 << 2)
(define+provide PL_MASK_ALT        #x8)    ;; (1 << 3)
(define+provide PL_MASK_NUM        #x10)   ;; (1 << 4)
(define+provide PL_MASK_ALTGR      #x20)   ;;  (1 << 5)
(define+provide PL_MASK_WIN        #x40)   ;; (1 << 6)
(define+provide PL_MASK_SCROLL     #x80)   ;; (1 << 7)
(define+provide PL_MASK_BUTTON1    #x100)  ;; (1 << 8)
(define+provide PL_MASK_BUTTON2    #x200)  ;; (1 << 9)
(define+provide PL_MASK_BUTTON3    #x400)  ;; (1 << 10)
(define+provide PL_MASK_BUTTON4    #x800)  ;; (1 << 11)
(define+provide PL_MASK_BUTTON5    #x1000) ;; (1 << 12)


(define-cstruct _PLGraphicsIn
  ([type _int] ;;  of event (CURRENTLY UNUSED)
   [state _uint] ;; key or button mask
   [keysym _uint] ;; key selected
   [button _uint] ;; mouse button selected
   [subwindow PLINT] ;; subwindow (alias subpage, alias subplot) number
   [string (_array/list _ubyte PL_MAXKEY)] ;; translated string
   [pX _int] ;; absolute device coordinates of pointer
   [pY _int]
   [dX PLFLT] ;; relative device coordinates of pointer
   [dY PLFLT] 
   [wX PLFLT] ;; world coordinates of pointer
   [wY PLFLT]))

(provide (matching-identifiers-out #rx".*PLGraphicsIn.*$" (all-defined-out)))


;; Structure for describing the plot window
(define+provide PL_MAXWINDOWS    64)     ;; Max number of windows/page tracked

(define-cstruct _PLWindow
  ;; min, max window rel dev coords
  ([dxmi PLFLT]
   [dxma PLFLT]
   [dymi PLFLT]
   [dyma PLFLT]
   ;; min, max window world coords
   [wxmi PLFLT]
   [wxma PLFLT]
   [wymi PLFLT]
   [wyma PLFLT]))
(provide (matching-identifiers-out #rx".*PLWindow.*$" (all-defined-out)))

;; Structure for doing display-oriented operations via escape commands
;; May add other attributes in time
(define-cstruct _PLDisplay
  ;; upper left hand corner
  ([x _uint]
   [y _uint]
   ;; window dimensions
   [width _uint]
   [height _uint]))
(provide (matching-identifiers-out #rx".*PLDisplay.*$" (all-defined-out)))

;;(struct-out)

;; Macro used (in some cases) to ignore value of argument
;; I don't plan on changing the value so you can hard-code it
(define+provide PL_NOTSET    -42)


;; See plcont.c for examples of the following

;;
;; PLfGrid is for passing (as a pointer to the first element) an arbitrarily
;; dimensioned array.  The grid dimensions MUST be stored, with a maximum of 3
;; dimensions assumed for now.
;;
(define-cstruct _PLfGrid
  ([f PLFLT_FE_POINTER]
   [nx PLINT]
   [ny PLINT]
   [nz PLINT]))

(provide (struct-out PLfGrid))

;;
;; PLfGrid2 is for passing (as an array of pointers) a 2d function array.  The
;; grid dimensions are passed for possible bounds checking.
;;
(define-cstruct _PLfGrid2
  ([f PLFLT_NC_MATRIX]
   [nx PLINT]
   [ny PLINT]))

;;
;; NOTE: a PLfGrid3 is a good idea here but there is no way to exploit it yet
;; so I'll leave it out for now.
;;

;;
;; PLcGrid is for passing (as a pointer to the first element) arbitrarily
;; dimensioned coordinate transformation arrays.  The grid dimensions MUST be
;; stored, with a maximum of 3 dimensions assumed for now.
;;
(define-cstruct _PLcGrid
  ([xg PLFLT_NC_FE_POINTER]
   [yg PLFLT_NC_FE_POINTER]
   [zg PLFLT_NC_FE_POINTER]
   [nx PLINT]
   [ny PLINT]
   [nz PLINT]))

;;
;; PLcGrid2 is for passing (as arrays of pointers) 2d coordinate
;; transformation arrays.  The grid dimensions are passed for possible bounds
;; checking.
;;
(define-cstruct _PLcGrid2
  ([xg PLFLT_NC_MATRIX]
   [yg PLFLT_NC_MATRIX]
   [zg PLFLT_NC_MATRIX]
   [nx PLINT]
   [ny PLINT]))

;;
;; NOTE: a PLcGrid3 is a good idea here but there is no way to exploit it yet
;; so I'll leave it out for now.
;;

;; Color limits:

;; Default number of colors for cmap0 and cmap1.
(define+provide PL_DEFAULT_NCOL0    16)
(define+provide PL_DEFAULT_NCOL1    128)
;; minimum and maximum PLINT RGB values.
(define+provide MIN_PLINT_RGB       0)
(define+provide MAX_PLINT_RGB       255)
;; minimum and maximum PLFLT cmap1 color index values.
(define+provide MIN_PLFLT_CMAP1     0.)
(define+provide MAX_PLFLT_CMAP1     1.)
;; minimum and maximum PLFLT alpha values.
(define+provide MIN_PLFLT_ALPHA     0.)
(define+provide MAX_PLFLT_ALPHA     1.)

;; PLColor is the usual way to pass an rgb color value.
(define-cstruct _PLColor
  ([r _uint8]
   [g _uint8]
   [b _uint8]
   [a PLFLT] ;; alpha
   [name PLCHAR_VECTOR]))


;; PLControlPt is how cmap1 control points are represented.
(define-cstruct _PLControlPt
  ([c1 PLFLT]                   ;; hue or red
   [c2 PLFLT]                   ;; lightness or green
   [c3 PLFLT]                   ;; saturation or blue
   [p PLFLT]                    ;; position
   [a PLFLT]                    ;; alpha (or transparency)
   [alt_hue_path _int]))        ;; if set, interpolate through h=0

;; A PLBufferingCB is a control block for interacting with devices
;; that support double buffering.
(define-cstruct _PLBufferingCB
  ([cmd PLINT]
   [result PLINT]))

(define+provide PLESC_DOUBLEBUFFERING_ENABLE     1)
(define+provide PLESC_DOUBLEBUFFERING_DISABLE    2)
(define+provide PLESC_DOUBLEBUFFERING_QUERY      3)

(define-cstruct _PLLabelDefaults
  ([exp_label_disp PLFLT]
   [exp_label_pos PLFLT]
   [exp_label_just PLFLT]))

;;
;; typedefs for access methods for arbitrary (i.e. user defined) data storage
;;

;;
;; This type of struct holds pointers to functions that are used to
;; get, set, modify, and test individual 2-D data points referenced by
;; a PLPointer or PLPointer.  How these
;; generic pointers are used depends entirely on the functions
;; that implement the various operations.  Certain common data
;; representations have predefined instances of this structure
;; prepopulated with pointers to predefined functions.
;;
(define-cstruct _plf2ops_t
  ([*get (_fun PLPointer PLINT PLINT -> PLFLT)]
   [*set (_fun PLPointer PLINT PLINT PLFLT -> PLFLT)]
   [*add (_fun PLPointer PLINT PLINT PLFLT -> PLFLT)]
   [*sub (_fun PLPointer PLINT PLINT PLFLT -> PLFLT)]
   [*mul (_fun PLPointer PLINT PLINT PLFLT -> PLFLT)]
   [*div (_fun PLPointer PLINT PLINT PLFLT -> PLFLT)]
   [*is_nan (_fun PLPointer PLINT PLINT -> PLINT)]
   [*minmax (_fun PLPointer PLINT PLINT PLFLT_NC_SCALAR PLFLT_NC_SCALAR -> _void)]
   ;;
   ;; f2eval is backwards compatible signature for "f2eval" functions that
   ;; existed before plf2ops "operator function families" were used.
   ;;
   [*f2eval (_fun PLINT PLINT PLPointer -> PLFLT)]))


(define+provide PLF2OPS _plf2ops_t-pointer/null)

;;
;; A struct to pass a buffer around
;;
(define-cstruct _plbuffer
  ([size _int]
   [buffer PLPointer]))


;; All void types
;; C routines callable from stub routines come first

;; set the format of the contour labels
(define-ffi+provide c_pl_setcontlabelformat
  (_fun (lexp : PLINT)
        (sigdig : PLINT) -> _void))

;; set offset and spacing of contour labels
(define-ffi+provide c_pl_setcontlabelparam
  (_fun (offset : PLFLT)
        (size : PLFLT)
        (spacing : PLFLT)
        (active : PLINT)
        -> _void))

;; Advance to subpage "page", or to the next one if "page" = 0.
(define-ffi+provide c_pladv
  (_fun (page : PLINT) -> _void))


;; Plot an arc
(define-ffi+provide c_plarc
  (_fun (x : PLFLT)
        (y : PLFLT)
        (a : PLFLT)
        (b : PLFLT)
        (angle1 : PLFLT)
        (angle2 : PLFLT)
        (rotate : PLFLT)
        (fill : PLBOOL)
        -> _void))

;; This functions similarly to plbox() except that the origin of the axes
;; is placed at the user-specified point (x0, y0).
(define-ffi+provide c_plaxes
  (_fun (x0 : PLFLT)
        (y0 : PLFLT)
        (xopt : PLCHAR_VECTOR)
        (xtick : PLFLT)
        (nxsub : PLINT)
        (yopt : PLCHAR_VECTOR)
        (ytick : PLFLT)
        (nysub : PLINT)
        -> _void))


;; Plot a histogram using x to store data values and y to store frequencies

;; Flags for plbin() - opt argument
(define+provide PL_BIN_DEFAULT     #x0)
(define+provide PL_BIN_CENTRED     #x1)
(define+provide PL_BIN_NOEXPAND    #x2)
(define+provide PL_BIN_NOEMPTY     #x4)

(define-ffi+provide c_plbin
  (_fun (nbin : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (opt : PLINT)
        -> _void))

;; Calculate broken-down time from continuous time for current stream.
(define-ffi+provide c_plbtime
  (_fun (year : PLINT_NC_SCALAR)
        (month : PLINT_NC_SCALAR)
        (day : PLINT_NC_SCALAR)
        (hour : PLINT_NC_SCALAR)
        (min : PLINT_NC_SCALAR)
        (sec : PLFLT_NC_SCALAR)
        (ctime : PLFLT)
        -> _void))

;; Start new page.  Should only be used with pleop().
(define-ffi+provide c_plbop
  (_fun -> _void))

;; This draws a box around the current viewport.
(define-ffi+provide c_plbox
  (_fun (xopt : PLCHAR_VECTOR)
        (xtick : PLFLT)
        (nxsub : PLINT)
        (yopt : PLCHAR_VECTOR)
        (ytick : PLFLT)
        (nysub : PLINT)
        -> _void))

;; This is the 3-d analogue of plbox().
(define-ffi+provide c_plbox3
  (_fun (xopt : PLCHAR_VECTOR)
        (xlabel :  PLCHAR_VECTOR)
        (xtick : PLFLT)
        (nxsub : PLINT)
        (yopt : PLCHAR_VECTOR)
        (ylabel : PLCHAR_VECTOR)
        (ytick : PLFLT)
        (nysub : PLINT)
        (zopt : PLCHAR_VECTOR)
        (zlabel : PLCHAR_VECTOR)
        (ztick : PLFLT)
        (nzsub : PLINT)
        -> _void))


;; Calculate world coordinates and subpage from relative device coordinates.
(define-ffi+provide c_plcalc_world
  (_fun (rx : PLFLT)
        (ry : PLFLT)
        (wx : PLFLT_NC_SCALAR)
        (wy : PLFLT_NC_SCALAR)
        (window : PLINT_NC_SCALAR)
        -> _void))

;; Clear current subpage.
(define-ffi+provide c_plclear
  (_fun -> _void))

;; Set color, map 0.  Argument is integer between 0 and 15.
(define-ffi+provide c_plcol0
  (_fun (icol0 : PLINT) -> _void))


;; Set color, map 1.  Argument is a float between 0. and 1.
(define-ffi+provide c_plcol1
  (_fun (col1 : PLFLT) -> _void))

;; Configure transformation between continuous and broken-down time (and
;; vice versa) for current stream.
(define-ffi+provide c_plconfigtime
  (_fun (scale : PLFLT)
        (offset1 : PLFLT)
        (offset2 : PLFLT)
        (ccontrol : PLINT)
        (ifbtime_offset : PLBOOL)
        (year : PLINT)
        (month : PLINT)
        (day : PLINT)
        (hour : PLINT)
        (min : PLINT)
        (sec : PLFLT)
        -> _void))

;; Draws a contour plot from data in f(nx,ny).  Is just a front-end to
;; plfcont, with a particular choice for f2eval and f2eval_data.
;;
(define-ffi+provide c_plcont
  (_fun (f : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (kx : PLINT)
        (lx : PLINT)
        (ky : PLINT)
        (ly : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        (pltr : *PLTRANSFORM_callback)
        (pltr_data : PLPointer)
        -> _void))

;; Draws a contour plot using the function evaluator f2eval and data stored
;; by way of the f2eval_data pointer.  This allows arbitrary organizations
;; of 2d array data to be used.
;;
(define-ffi+provide plfcont
  (_fun (f2eval : *PLF2EVAL_callback)
        (f2eval_data : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (kx : PLINT)
        (lx : PLINT)
        (ky : PLINT)
        (ly : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        (pltr : *PLTRANSFORM_callback)
        (pltr_data : PLPointer)
        -> _void))

;; Copies state parameters from the reference stream to the current stream.
(define-ffi+provide c_plcpstrm
  (_fun (iplsr : PLINT)
        (flags : PLBOOL)
        -> _void))

;; Calculate continuous time from broken-down time for current stream.
(define-ffi+provide c_plctime
  (_fun (year : PLINT)
        (month : PLINT)
        (day : PLINT)
        (hour : PLINT)
        (min : PLINT)
        (sec : PLFLT)
        (ctime : PLFLT_NC_SCALAR)
        -> _void))

;; Converts input values from relative device coordinates to relative plot
;; coordinates.
(define-ffi+provide pldid2pc
  (_fun (xmin : PLFLT_NC_SCALAR)
        (ymin : PLFLT_NC_SCALAR)
        (xmax : PLFLT_NC_SCALAR)
        (ymax : PLFLT_NC_SCALAR)
        -> _void))

;; Converts input values from relative plot coordinates to relative
;; device coordinates.
(define-ffi+provide pldip2dc
  (_fun (xmin : PLFLT_NC_SCALAR)
        (ymin : PLFLT_NC_SCALAR)
        (xmax : PLFLT_NC_SCALAR)
        (ymax : PLFLT_NC_SCALAR)
        -> _void))

;; End a plotting session for all open streams.
(define-ffi+provide c_plend
  (_fun -> _void))

;; End a plotting session for the current stream only.
(define-ffi+provide c_plend1
  (_fun -> _void))

;; Simple interface for defining viewport and window.
(define-ffi+provide c_plenv
  (_fun (xmin xmax ymin ymax just axis) :: 
        (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (just : PLINT)
        (axis : PLINT)
        -> _void))

;; similar to plenv() above, but in multiplot mode does not advance the subpage,
;; instead the current subpage is cleared
(define-ffi+provide c_plenv0
  (_fun (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (just : PLINT)
        (axis : PLINT)
        -> _void))

;; End current page.  Should only be used with plbop().
(define-ffi+provide c_pleop
  (_fun -> _void))





;; Plot horizontal error bars (xmin(i),y(i)) to (xmax(i),y(i))
(define-ffi+provide c_plerrx
  (_fun (n : PLINT)
        (xmin : PLFLT_VECTOR)
        (xmax : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        -> _void))

;; Plot vertical error bars (x,ymin(i)) to (x(i),ymax(i))
(define-ffi+provide c_plerry
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (ymin : PLFLT_VECTOR)
        (ymax : PLFLT_VECTOR)
        -> _void))

;; Advance to the next family file on the next new page
(define-ffi+provide c_plfamadv
  (_fun -> _void))

;; Pattern fills the polygon bounded by the input points.
(define-ffi+provide c_plfill
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        -> _void))

;; Pattern fills the 3d polygon bounded by the input points.
(define-ffi+provide c_plfill3
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_VECTOR)
        -> _void))

;; Flushes the output stream.  Use sparingly, if at all.
(define-ffi+provide c_plflush
  (_fun -> _void))

;; Sets the global font flag to 'ifont'.
(define-ffi+provide c_plfont
  (_fun (ifont : PLINT)
        -> _void))

;; Load specified font set.
(define-ffi+provide c_plfontld
  (_fun (fnt : PLINT)
        -> _void))

;; Get character default height and current (scaled) height
(define-ffi+provide c_plgchr
  (_fun () ::
        (p_def : (_ptr o PLFLT))
        (p_ht : (_ptr o PLFLT))
        -> _void
        -> (make-hash
            (list (cons 'p_def p_def)
                  (cons 'p_ht p_ht)))))

;; Get the color map 1 range used in continuous plots
(define-ffi+provide c_plgcmap1_range
  (_fun (min_color : PLFLT_NC_SCALAR)
        (max_color : PLFLT_NC_SCALAR)
        -> _void))

;; Returns 8 bit RGB values for given color from color map 0
(define-ffi+provide c_plgcol0
  (_fun (icol0) ::
        (icol0 : PLINT)
        (r :     (_ptr o PLINT))
        (g :     (_ptr o PLINT))
        (b :     (_ptr o PLINT))
        -> _void
        -> (make-hash
            (list (cons 'r r)
                  (cons 'g g)
                  (cons 'b b)))))

;; Returns 8 bit RGB values for given color from color map 0 and alpha value
(define-ffi+provide c_plgcol0a
  (_fun (icol0) ::
        (icol0 : PLINT)
        (r : (_ptr o PLINT))
        (g : (_ptr o PLINT))
        (b : (_ptr o PLINT))
        (alpha : (_ptr o PLFLT))
        -> _void
        -> (make-hash
            (list (cons 'r r)
                  (cons 'g g)
                  (cons 'b b)
                  (cons 'alpha alpha)))))

;; Returns the background color by 8 bit RGB value
(define-ffi+provide c_plgcolbg
  (_fun () ::
        (r : (_ptr o PLINT))
        (g : (_ptr o PLINT))
        (b : (_ptr o PLINT))
        -> _void
        -> (make-hash
            (list (cons 'r r)
                  (cons 'g g)
                  (cons 'b b)))))

;; Returns the background color by 8 bit RGB value and alpha value
(define-ffi+provide c_plgcolbga
  (_fun () ::
        (r :     (_ptr o PLINT))
        (g :     (_ptr o PLINT))
        (b :     (_ptr o PLINT))
        (alpha : (_ptr o PLFLT))
        -> _void
        -> (make-hash
            (list (cons 'r r)
                  (cons 'g g)
                  (cons 'b b)
                  (cons 'alpha alpha)))))

;; Returns the current compression setting
(define-ffi+provide c_plgcompression
  (_fun () ::
        (compression : (_ptr o PLINT))
        -> _void
        -> compression))

;; Get the current device (keyword) name
(define-ffi+provide c_plgdev
  (_fun () ::
        (p_dev : _pointer = (malloc _pointer 'atomic-interior))
        -> _void
        -> (cast p_dev _pointer _string/eof)))

;; Retrieve current window into device space
(define-ffi+provide c_plgdidev
  (_fun () ::
        (p_mar :    (_ptr o PLFLT))
        (p_aspect : (_ptr o PLFLT))
        (p_jx :     (_ptr o PLFLT))
        (p_jy :     (_ptr o PLFLT))
        -> _void
        -> (make-hash
            (list (cons 'p_mar p_mar)
                  (cons 'p_aspect p_aspect)
                  (cons 'p_jx p_jx)
                  (cons 'p_jy p_jy)))))

;; Get plot orientation
(define-ffi+provide c_plgdiori
  (_fun () ::
        (p_rot : (_ptr o PLFLT))
        -> _void
        -> p_rot))

;; Retrieve current window into plot space
(define-ffi+provide c_plgdiplt
  (_fun (p_xmin : (_ptr o PLFLT))
        (p_ymin : (_ptr o PLFLT))
        (p_xmax : (_ptr o PLFLT))
        (p_ymax : (_ptr o PLFLT))
        -> _void
        -> (make-hash
            (list (cons 'p_xmin p_xmin)
                  (cons 'p_ymin p_ymin)
                  (cons 'p_xmax p_xmax)
                  (cons 'p_ymax p_ymax)))))

;; Get the drawing mode
(define-ffi+provide c_plgdrawmode
  (_fun -> _void))

;; Get FCI (font characterization integer)
(define-ffi+provide c_plgfci
  (_fun (p_fci : PLUNICODE_NC_SCALAR)
        -> _void))

;; Get family file parameters
(define-ffi+provide c_plgfam
  (_fun (p_fam : PLINT_NC_SCALAR)
        (p_num : PLINT_NC_SCALAR)
        (p_bmax : PLINT_NC_SCALAR)
        -> _void))

;; Get the (current) output file name.  Must be preallocated to >80 bytes
(define-ffi+provide c_plgfnam
  (_fun (fnam : PLCHAR_NC_VECTOR)
        -> _void))

;; Get the current font family, style and weight
(define-ffi+provide c_plgfont
  (_fun (p_family : PLINT_NC_SCALAR)
        (p_style : PLINT_NC_SCALAR)
        (p_weight : PLINT_NC_SCALAR)
        -> _void))

;; Get the (current) run level.
(define-ffi+provide c_plglevel
  (_fun () ::
        (p_level : (_ptr o PLINT))
        -> _void
        -> p_level))

;; Get output device parameters.
(define-ffi+provide c_plgpage
  (_fun () ::
        (p_xp : (_ptr o PLFLT))
        (p_yp : (_ptr o PLFLT))
        (p_xleng : (_ptr o PLINT))
        (p_yleng : (_ptr o PLINT))
        (p_xoff : (_ptr o PLINT))
        (p_yoff : (_ptr o PLINT))
        -> _void
        ->  (make-hash
             (list (cons 'p_xp p_xp)
                   (cons 'p_yp p_yp)
                   (cons 'p_xleng p_xleng)
                   (cons 'p_yleng p_yleng)
                   (cons 'p_xoff p_xoff)
                   (cons 'p_yoff p_yoff)))))

;; Switches to graphics screen.
(define-ffi+provide c_plgra
  (_fun -> _void))

;; Draw gradient in polygon.
(define-ffi+provide c_plgradient
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (angle : PLFLT)
        -> _void))

;; grid irregularly sampled data
(define-ffi+provide c_plgriddata
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_VECTOR)
        (npts : PLINT)
        (xg : PLFLT_VECTOR)
        (nptsx : PLINT)
        (yg : PLFLT_VECTOR)
        (nptsy : PLINT)
        (zg : PLFLT_NC_MATRIX)
        (type : PLINT)
        (data : PLFLT)
        -> _void))

(define-ffi+provide plfgriddata
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_VECTOR)
        (npts : PLINT)
        (xg : PLFLT_VECTOR)
        (nptsx : PLINT)
        (yg : PLFLT_VECTOR)
        (nptsy : PLINT)
        (zops : PLF2OPS)
        (zgp : PLPointer)
        (type : PLINT)
        (data : PLFLT)
        -> _void))


(define+provide GRID_CSA       1) ;; Bivariate Cubic Spline approximation
(define+provide GRID_DTLI      2) ;; Delaunay Triangulation Linear Interpolation
(define+provide GRID_NNI       3) ;; Natural Neighbors Interpolation
(define+provide GRID_NNIDW     4) ;; Nearest Neighbors Inverse Distance Weighted
(define+provide GRID_NNLI      5) ;; Nearest Neighbors Linear Interpolation
(define+provide GRID_NNAIDW    6) ;; Nearest Neighbors Around Inverse Distance Weighted



;; Get subpage boundaries in absolute coordinates
(define-ffi+provide c_plgspa
  (_fun ()::
        (xmin : (_ptr o PLFLT))
        (xmax : (_ptr o PLFLT))
        (ymin : (_ptr o PLFLT))
        (ymax : (_ptr o PLFLT))
        -> _void
        -> (values xmin xmax ymin ymax)))

;; Get current stream number.
(define-ffi+provide c_plgstrm
  (_fun () ::
        (p_strm : (_ptr o PLINT))
        -> _void
        -> p_strm))

;; Get the current library version number
(define-ffi+provide c_plgver
  (_fun (p_ver : _pointer = (malloc _uint8 100))
        -> _void
        -> (cast p_ver _pointer _string)))

;; Get viewport boundaries in normalized device coordinates
(define-ffi+provide c_plgvpd
  (_fun () ::
        (xmin : (_ptr o PLFLT))
        (xmax : (_ptr o PLFLT))
        (ymin : (_ptr o PLFLT))
        (ymax : (_ptr o PLFLT))
        -> _void
        -> (values xmin xmax ymin ymax)))

;; Get viewport boundaries in world coordinates
(define-ffi+provide c_plgvpw
  (_fun () ::
        (xmin : (_ptr o PLFLT))
        (xmax : (_ptr o PLFLT))
        (ymin : (_ptr o PLFLT))
        (ymax : (_ptr o PLFLT))
        -> _void
        -> (values xmin xmax ymin ymax)))

;; Get x axis labeling parameters
(define-ffi+provide c_plgxax
  (_fun (p_digmax : PLINT_NC_SCALAR)
        (p_digits : PLINT_NC_SCALAR)
        -> _void))

;; Get y axis labeling parameters
(define-ffi+provide c_plgyax
  (_fun (p_digmax : PLINT_NC_SCALAR)
        (p_digits : PLINT_NC_SCALAR)
        -> _void))

;; Get z axis labeling parameters
(define-ffi+provide c_plgzax
  (_fun (p_digmax : PLINT_NC_SCALAR)
        (p_digits : PLINT_NC_SCALAR)
        -> _void))


;; Draws a histogram of n values of a variable in array data[0..n-1]

;; Flags for plhist() - opt argument; note: some flags are passed to
;; plbin() for the actual plotting
(define+provide PL_HIST_DEFAULT            #x00)
(define+provide PL_HIST_NOSCALING          #x01)
(define+provide PL_HIST_IGNORE_OUTLIERS    #x02)
(define+provide PL_HIST_NOEXPAND           #x08)
(define+provide PL_HIST_NOEMPTY            #x10)


(define-ffi+provide c_plhist
  (_fun (n : PLINT)
        (data : PLFLT_VECTOR)
        (datmin : PLFLT)
        (datmax : PLFLT)
        (nbin : PLINT)
        (opt : PLINT)
        -> _void))

;; Functions for converting between HLS and RGB color space
(define-ffi+provide c_plhlsrgb
  (_fun (h l s) ::
        (h : PLFLT)
        (l : PLFLT)
        (s : PLFLT)
        (p_r : (_ptr o PLFLT))
        (p_g : (_ptr o PLFLT))
        (p_b : (_ptr o PLFLT))
        -> _void
        -> (values p_r p_g p_b)))

;; Initializes PLplot, using preset or default options
(define-ffi+provide c_plinit
  (_fun -> _void))

;; Draws a line segment from (x1, y1) to (x2, y2).
(define-ffi+provide c_pljoin
  (_fun (x1 : PLFLT)
        (y1 : PLFLT)
        (x2 : PLFLT)
        (y2 : PLFLT)
        -> _void))

;; Simple routine for labelling graphs.
(define-ffi+provide c_pllab
  (_fun (xlabel : PLCHAR_VECTOR)
        (ylabel : PLCHAR_VECTOR)
        (tlabel : PLCHAR_VECTOR)
        -> _void))

;;flags used for position argument of both pllegend and plcolorbar
(define+provide PL_POSITION_NULL             #x0)
(define+provide PL_POSITION_LEFT             #x1)
(define+provide PL_POSITION_RIGHT            #x2)
(define+provide PL_POSITION_TOP              #x4)
(define+provide PL_POSITION_BOTTOM           #x8)
(define+provide PL_POSITION_INSIDE           #x10)
(define+provide PL_POSITION_OUTSIDE          #x20)
(define+provide PL_POSITION_VIEWPORT         #x40)
(define+provide PL_POSITION_SUBPAGE          #x80)

;; Flags for pllegend.
(define+provide PL_LEGEND_NULL               #x0)
(define+provide PL_LEGEND_NONE               #x1)
(define+provide PL_LEGEND_COLOR_BOX          #x2)
(define+provide PL_LEGEND_LINE               #x4)
(define+provide PL_LEGEND_SYMBOL             #x8)
(define+provide PL_LEGEND_TEXT_LEFT          #x10)
(define+provide PL_LEGEND_BACKGROUND         #x20)
(define+provide PL_LEGEND_BOUNDING_BOX       #x40)
(define+provide PL_LEGEND_ROW_MAJOR          #x80)

;; Flags for plcolorbar
(define+provide PL_COLORBAR_NULL             #x0)
(define+provide PL_COLORBAR_LABEL_LEFT       #x1)
(define+provide PL_COLORBAR_LABEL_RIGHT      #x2)
(define+provide PL_COLORBAR_LABEL_TOP        #x4)
(define+provide PL_COLORBAR_LABEL_BOTTOM     #x8)
(define+provide PL_COLORBAR_IMAGE            #x10)
(define+provide PL_COLORBAR_SHADE            #x20)
(define+provide PL_COLORBAR_GRADIENT         #x40)
(define+provide PL_COLORBAR_CAP_NONE         #x80)
(define+provide PL_COLORBAR_CAP_LOW          #x100)
(define+provide PL_COLORBAR_CAP_HIGH         #x200)
(define+provide PL_COLORBAR_SHADE_LABEL      #x400)
(define+provide PL_COLORBAR_ORIENT_RIGHT     #x800)
(define+provide PL_COLORBAR_ORIENT_TOP       #x1000)
(define+provide PL_COLORBAR_ORIENT_LEFT      #x2000)
(define+provide PL_COLORBAR_ORIENT_BOTTOM    #x4000)
(define+provide PL_COLORBAR_BACKGROUND       #x8000)
(define+provide PL_COLORBAR_BOUNDING_BOX     #x10000)

;; Flags for drawing mode
(define+provide PL_DRAWMODE_UNKNOWN          #x0)
(define+provide PL_DRAWMODE_DEFAULT          #x1)
(define+provide PL_DRAWMODE_REPLACE          #x2)
(define+provide PL_DRAWMODE_XOR              #x4)

;; Routine for drawing discrete line, symbol, or cmap0 legends
(define-ffi+provide c_pllegend
  (_fun (p_legend_width : PLFLT_NC_SCALAR)
        (p_legend_height : PLFLT_NC_SCALAR)
        (opt : PLINT)
        (position : PLINT)
        (x : PLFLT)
        (y : PLFLT)
        (plot_width : PLFLT)
        (bg_color : PLINT)
        (bb_color : PLINT)
        (bb_style : PLINT)
        (nrow : PLINT)
        (ncolumn : PLINT)
        (nlegend : PLINT)
        (opt_array : PLINT_VECTOR)
        (text_offset : PLFLT)
        (text_scale : PLFLT)
        (text_spacing : PLFLT)
        (text_justification : PLFLT)
        (text_colors : PLINT_VECTOR)
        (text : PLCHAR_MATRIX)
        (box_colors : PLINT_VECTOR)
        (box_patterns : PLINT_VECTOR)
        (box_scales : PLFLT_VECTOR)
        (box_line_widths : PLFLT_VECTOR)
        (line_colors : PLINT_VECTOR)
        (line_styles : PLINT_VECTOR)
        (line_widths : PLFLT_VECTOR)
        (symbol_colors : PLINT_VECTOR)
        (symbol_scales : PLFLT_VECTOR)
        (symbol_numbers : PLINT_VECTOR)
        (symbols : PLCHAR_MATRIX)
        -> _void))

;; Routine for drawing continuous colour legends
(define-ffi+provide c_plcolorbar
  (_fun (p_colorbar_width : PLFLT_NC_SCALAR)
        (p_colorbar_height : PLFLT_NC_SCALAR)
        (opt : PLINT)
        (position : PLINT)
        (x : PLFLT)
        (y : PLFLT)
        (x_length : PLFLT)
        (y_length : PLFLT)
        (bg_color : PLINT)
        (bb_color : PLINT)
        (bb_style : PLINT)
        (low_cap_color : PLFLT)
        (high_cap_color : PLFLT)
        (cont_color : PLINT)
        (cont_width : PLFLT)
        (n_labels : PLINT)
        (label_opts : PLINT_VECTOR)
        (labels : PLCHAR_MATRIX)
        (n_axes : PLINT)
        (axis_opts : PLCHAR_MATRIX)
        (ticks : PLFLT_VECTOR)
        (sub_ticks : PLINT_VECTOR)
        (n_values : PLINT_VECTOR)
        (values : PLFLT_MATRIX)
        -> _void))

;; Sets position of the light source
(define-ffi+provide c_pllightsource
  (_fun (x : PLFLT)
        (y : PLFLT)
        (z : PLFLT)
        -> _void))

;; Draws line segments connecting a series of points.
(define-ffi+provide c_plline
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        -> _void))

;; Draws a line in 3 space.
(define-ffi+provide c_plline3
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_VECTOR)
        -> _void))

;; Set line style.
(define-ffi+provide c_pllsty
  (_fun (lin : PLINT)
        -> _void))

;; Plot continental outline in world coordinates
(define-ffi+provide c_plmap
  (_fun (mapform : *PLMAPFORM_callback)
        (name : PLCHAR_VECTOR)
        (minx : PLFLT)
        (maxx : PLFLT)
        (miny : PLFLT)
        (maxy : PLFLT)
        -> _void))

;; UNDEFINED
;; Plot map outlines
;; (define-ffi+provide c_plmapline
;;   (_fun (mapform : *PLMAPFORM_callback)
;;         (name : PLCHAR_VECTOR)
;;         (minx : PLFLT)
;;         (maxx : PLFLT)
;;         (miny : PLFLT)
;;         (maxy : PLFLT)
;;         (plotentries : PLINT_VECTOR)
;;         (nplotentries : PLINT)
;;         -> _void))

;; Plot map points
;; (define-ffi+provide c_plmapstring
;;   (_fun (mapform : *PLMAPFORM_callback)
;;         (name : PLCHAR_VECTOR)
;;         (string : PLCHAR_VECTOR)
;;         (minx : PLFLT)
;;         (maxx : PLFLT)
;;         (miny : PLFLT)
;;         (maxy : PLFLT)
;;         (plotentries : PLINT_VECTOR)
;;         (nplotentries : PLINT)
;;         -> _void))

;; Plot map text
;; (define-ffi+provide c_plmaptex
;;   (_fun (mapform : *PLMAPFORM_callback)
;;         (name : PLCHAR_VECTOR)
;;         (dx : PLFLT)
;;         (dy : PLFLT)
;;         (just : PLFLT)
;;         (text : PLCHAR_VECTOR)
;;         (minx : PLFLT)
;;         (maxx : PLFLT)
;;         (miny : PLFLT)
;;         (maxy : PLFLT)
;;         (plotentry : PLINT)
;;         -> _void))

;; Plot map fills
;; (define-ffi+provide c_plmapfill
;;   (_fun (mapform : *PLMAPFORM_callback)
;;         (name : PLCHAR_VECTOR)
;;         (minx : PLFLT)
;;         (maxx : PLFLT)
;;         (miny : PLFLT)
;;         (maxy : PLFLT)
;;         (plotentries : PLINT_VECTOR)
;;         (nplotentries : PLINT)
;;         -> _void))

;; Plot the latitudes and longitudes on the background.
(define-ffi+provide c_plmeridians
  (_fun (mapform : *PLMAPFORM_callback)
        (dlong : PLFLT)
        (dlat : PLFLT)
        (minlong : PLFLT)
        (maxlong : PLFLT)
        (minlat : PLFLT)
        (maxlat : PLFLT)
        -> _void))

;; Plots a mesh representation of the function z[x][y].
(define-ffi+provide c_plmesh
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        -> _void))

;; Like plmesh, but uses an evaluator function to access z data from zp
(define-ffi+provide plfmesh
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (zops : PLF2OPS)
        (zp : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        -> _void))

;; Plots a mesh representation of the function z[x][y] with contour
(define-ffi+provide c_plmeshc
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        -> _void))

;; Like plmeshc, but uses an evaluator function to access z data from zp
(define-ffi+provide plfmeshc
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (zops : PLF2OPS)
        (zp : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        -> _void))

;; Creates a new stream and makes it the default.
(define-ffi+provide c_plmkstrm
  (_fun () ::
        (p_strm : (_ptr o PLINT))
        -> _void
        -> p_strm))

;; Prints out "text" at specified position relative to viewport
(define-ffi+provide c_plmtex
  (_fun (side : PLCHAR_VECTOR)
        (disp : PLFLT)
        (pos : PLFLT)
        (just : PLFLT)
        (text : PLCHAR_VECTOR)
        -> _void))

;; Prints out "text" at specified position relative to viewport (3D)
(define-ffi+provide c_plmtex3
  (_fun (side : PLCHAR_VECTOR)
        (disp : PLFLT)
        (pos : PLFLT)
        (just : PLFLT)
        (text : PLCHAR_VECTOR)
        -> _void))

;; Plots a 3-d representation of the function z[x][y].
(define-ffi+provide c_plot3d
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (side : PLBOOL)
        -> _void))

;; Like plot3d, but uses an evaluator function to access z data from zp
(define-ffi+provide plfplot3d
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (zops : PLF2OPS)
        (zp : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (side : PLBOOL)
        -> _void))

;; Plots a 3-d representation of the function z[x][y] with contour.
(define-ffi+provide c_plot3dc
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        -> _void))

;; Like plot3dc, but uses an evaluator function to access z data from zp
(define-ffi+provide plfplot3dc
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (zops : PLF2OPS)
        (zp : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        -> _void))

;; Plots a 3-d representation of the function z[x][y] with contour and
;; y index limits.
(define-ffi+provide c_plot3dcl
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        (indexxmin : PLINT)
        (indexxmax : PLINT)
        (indexymin : PLINT_VECTOR)
        (indexymax : PLINT_VECTOR)
        -> _void))

;; Like plot3dcl, but uses an evaluator function to access z data from zp
(define-ffi+provide plfplot3dcl
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (zops : PLF2OPS)
        (zp : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        (indexxmin : PLINT)
        (indexxmax : PLINT)
        (indexymin : PLINT_VECTOR)
        (indexymax : PLINT_VECTOR)
        -> _void))

;;
;; definitions for the opt argument in plot3dc() and plsurf3d()
;;
;; DRAW_LINEX *must* be 1 and DRAW_LINEY *must* be 2, because of legacy code
;;
(define+provide DRAW_LINEX     #x001) ;; draw lines parallel to the X axis
(define+provide DRAW_LINEY     #x002) ;; draw lines parallel to the Y axis
(define+provide DRAW_LINEXY    #x003) ;; draw lines parallel to both the X and Y axis
(define+provide MAG_COLOR      #x004) ;; draw the mesh with a color dependent of the magnitude
(define+provide BASE_CONT      #x008) ;; draw contour plot at bottom xy plane
(define+provide TOP_CONT       #x010) ;; draw contour plot at top xy plane
(define+provide SURF_CONT      #x020) ;; draw contour plot at surface
(define+provide DRAW_SIDES     #x040) ;; draw sides
(define+provide FACETED        #x080) ;; draw outline for each square that makes up the surface
(define+provide MESH           #x100) ;; draw mesh

;;
;;  valid options for plot3dc():
;;
;;  DRAW_SIDES, BASE_CONT, TOP_CONT (not yet),
;;  MAG_COLOR, DRAW_LINEX, DRAW_LINEY, DRAW_LINEXY.
;;
;;  valid options for plsurf3d():
;;
;;  MAG_COLOR, BASE_CONT, SURF_CONT, FACETED, DRAW_SIDES.
;;

;; Set fill pattern directly.
(define-ffi+provide c_plpat
  (_fun (nlin : PLINT)
        (inc : PLINT_VECTOR)
        (del : PLINT_VECTOR)
        -> _void))

;; Draw a line connecting two points, accounting for coordinate transforms
(define-ffi+provide c_plpath
  (_fun (n : PLINT)
        (x1 : PLFLT)
        (y1 : PLFLT)
        (x2 : PLFLT)
        (y2 : PLFLT)
        -> _void))

;; Plots array y against x for n points using ASCII code "code".
(define-ffi+provide c_plpoin
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (code : PLINT)
        -> _void))

;; Draws a series of points in 3 space.
(define-ffi+provide c_plpoin3
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_VECTOR)
        (code : PLINT)
        -> _void))

;; Draws a polygon in 3 space.
(define-ffi+provide c_plpoly3
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_VECTOR)
        (draw : PLBOOL_VECTOR)
        (ifcc : PLBOOL)
        -> _void))

;; Set the floating point precision (in number of places) in numeric labels.
(define-ffi+provide c_plprec
  (_fun (setp : PLINT)
        (prec : PLINT)
        -> _void))

;; Set fill pattern, using one of the predefined patterns.
(define-ffi+provide c_plpsty
  (_fun (patt : PLINT)
        -> _void))

;; Prints out "text" at world cooordinate (x,y).
(define-ffi+provide c_plptex
  (_fun (x : PLFLT)
        (y : PLFLT)
        (dx : PLFLT)
        (dy : PLFLT)
        (just : PLFLT)
        (text : PLCHAR_VECTOR)
        -> _void))

;; Prints out "text" at world cooordinate (x,y,z).
(define-ffi+provide c_plptex3
  (_fun (wx : PLFLT)
        (wy : PLFLT)
        (wz : PLFLT)
        (dx : PLFLT)
        (dy : PLFLT)
        (dz : PLFLT)
        (sx : PLFLT)
        (sy : PLFLT)
        (sz : PLFLT)
        (just : PLFLT)
        (text : PLCHAR_VECTOR)
        -> _void))

;; Random number generator based on Mersenne Twister.
;; Obtain real random number in range [0,1].
(define-ffi+provide c_plrandd
  (_fun -> _void))

;; Replays contents of plot buffer to current device/file.
(define-ffi+provide c_plreplot
  (_fun -> _void))

;; Functions for converting between HLS and RGB color space
(define-ffi+provide c_plrgbhls
  (_fun (r : PLFLT)
        (g : PLFLT)
        (b : PLFLT)
        (p_h : PLFLT_NC_SCALAR)
        (p_l : PLFLT_NC_SCALAR)
        (p_s : PLFLT_NC_SCALAR)
        -> _void))

;; Set character height.
(define-ffi+provide c_plschr
  (_fun (def : PLFLT)
        (scale : PLFLT)
        -> _void))

;; Set color map 0 colors by 8 bit RGB values
(define-ffi+provide c_plscmap0
  (_fun (r : PLINT_VECTOR)
        (g : PLINT_VECTOR)
        (b : PLINT_VECTOR)
        (ncol0 : PLINT)
        -> _void))

;; Set color map 0 colors by 8 bit RGB values and alpha values
(define-ffi+provide c_plscmap0a
  (_fun (r : PLINT_VECTOR)
        (g : PLINT_VECTOR)
        (b : PLINT_VECTOR)
        (alpha : PLFLT_VECTOR)
        (ncol0 : PLINT)
        -> _void))

;; Set number of colors in cmap 0
(define-ffi+provide c_plscmap0n
  (_fun (ncol0 : PLINT)
        -> _void))

;; Set color map 1 colors by 8 bit RGB values
(define-ffi+provide c_plscmap1
  (_fun (r : PLINT_VECTOR)
        (g : PLINT_VECTOR)
        (b : PLINT_VECTOR)
        (ncol1 : PLINT)
        -> _void))

;; Set color map 1 colors by 8 bit RGB and alpha values
(define-ffi+provide c_plscmap1a
  (_fun (r : PLINT_VECTOR)
        (g : PLINT_VECTOR)
        (b : PLINT_VECTOR)
        (alpha : PLFLT_VECTOR)
        (ncol1 : PLINT)
        -> _void))

;; Set color map 1 colors using a piece-wise linear relationship between
;; intensity [0,1] (cmap 1 index) and position in HLS or RGB color space.
(define-ffi+provide c_plscmap1l
  (_fun (itype : PLBOOL)
        (npts : PLINT)
        (intensity : PLFLT_VECTOR)
        (coord1 : PLFLT_VECTOR)
        (coord2 : PLFLT_VECTOR)
        (coord3 : PLFLT_VECTOR)
        (alt_hue_path : PLBOOL_VECTOR)
        -> _void))

;; Set color map 1 colors using a piece-wise linear relationship between
;; intensity [0,1] (cmap 1 index) and position in HLS or RGB color space.
;; Will also linear interpolate alpha values.
(define-ffi+provide c_plscmap1la
  (_fun (itype : PLBOOL)
        (npts : PLINT)
        (intensity : PLFLT_VECTOR)
        (coord1 : PLFLT_VECTOR)
        (coord2 : PLFLT_VECTOR)
        (coord3 : PLFLT_VECTOR)
        (alpha : PLFLT_VECTOR)
        (alt_hue_path : PLBOOL_VECTOR)
        -> _void))

;; Set number of colors in cmap 1
(define-ffi+provide c_plscmap1n
  (_fun (ncol1 : PLINT)
        -> _void))

;; Set the color map 1 range used in continuous plots
(define-ffi+provide c_plscmap1_range
  (_fun (min_color : PLFLT)
        (max_color : PLFLT)
        -> _void))

;; Set a given color from color map 0 by 8 bit RGB value
(define-ffi+provide c_plscol0
  (_fun (icol0 : PLINT)
        (r : PLINT)
        (g : PLINT)
        (b : PLINT)
        -> _void))

;; Set a given color from color map 0 by 8 bit RGB value
(define-ffi+provide c_plscol0a
  (_fun (icol0 : PLINT)
        (r : PLINT)
        (g : PLINT)
        (b : PLINT)
        (alpha : PLFLT)
        -> _void))

;; Set the background color by 8 bit RGB value
(define-ffi+provide c_plscolbg
  (_fun (r : PLINT)
        (g : PLINT)
        (b : PLINT)
        -> _void))

;; Set the background color by 8 bit RGB value and alpha value
(define-ffi+provide c_plscolbga
  (_fun (r : PLINT)
        (g : PLINT)
        (b : PLINT)
        (alpha : PLFLT)
        -> _void))

;; Used to globally turn color output on/off
(define-ffi+provide c_plscolor
  (_fun (color : PLINT)
        -> _void))

;; Set the compression level
(define-ffi+provide c_plscompression
  (_fun (compression : PLINT)
        -> _void))

;; Set the device (keyword) name
(define-ffi+provide c_plsdev
  (_fun (devname : PLCHAR_VECTOR)
        -> _void))

;; Set window into device space using margin, aspect ratio, and
;; justification
(define-ffi+provide c_plsdidev
  (_fun (mar : PLFLT)
        (aspect : PLFLT)
        (jx : PLFLT)
        (jy : PLFLT)
        -> _void))

;; Set up transformation from metafile coordinates.
(define-ffi+provide c_plsdimap
  (_fun (dimxmin : PLINT)
        (dimxmax : PLINT)
        (dimymin : PLINT)
        (dimymax : PLINT)
        (dimxpmm : PLFLT)
        (dimypmm : PLFLT)
        -> _void))

;; Set plot orientation, specifying rotation in units of pi/2.
(define-ffi+provide c_plsdiori
  (_fun (rot : PLFLT)
        -> _void))

;; Set window into plot space
(define-ffi+provide c_plsdiplt
  (_fun (xmin : PLFLT)
        (ymin : PLFLT)
        (xmax : PLFLT)
        (ymax : PLFLT)
        -> _void))

;; Set window into plot space incrementally (zoom)
(define-ffi+provide c_plsdiplz
  (_fun (xmin : PLFLT)
        (ymin : PLFLT)
        (xmax : PLFLT)
        (ymax : PLFLT)
        -> _void))

;; Set the drawing mode
(define-ffi+provide c_plsdrawmode
  (_fun (mode : PLINT)
        -> _void))

;; Set seed for internal random number generator
(define-ffi+provide c_plseed
  (_fun (seed : _uint)
        -> _void))

;; Set the escape character for text strings.
(define-ffi+provide c_plsesc
  (_fun (esc : _uint8)
        -> _void))

;; Set family file parameters
(define-ffi+provide c_plsfam
  (_fun (fam : PLINT)
        (num : PLINT)
        (bmax : PLINT)
        -> _void))

;; Set FCI (font characterization integer)
(define-ffi+provide c_plsfci
  (_fun (fci : PLUNICODE)
        -> _void))

;; Set the output file name.
(define-ffi+provide c_plsfnam
  (_fun (fnam : PLCHAR_VECTOR)
        -> _void))

;; Set the current font family, style and weight
(define-ffi+provide c_plsfont
  (_fun (family : PLINT)
        (style : PLINT)
        (weight : PLINT)
        -> _void))

;; Shade region.
(define-ffi+provide c_plshade
  (_fun (a : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (defined : *PLDEFINED_callback)
        (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (shade_min : PLFLT)
        (shade_max : PLFLT)
        (sh_cmap : PLINT)
        (sh_color : PLFLT)
        (sh_width : PLFLT)
        (min_color : PLINT)
        (min_width : PLFLT)
        (max_color : PLINT)
        (max_width : PLFLT)
        (fill : *PLFILL_callback)
        (rectangular : PLBOOL)
        (pltr : *PLTRANSFORM_callback)
        (pltr_data : PLPointer)
        -> _void))


(define-ffi+provide c_plshades
  (_fun (a : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (defined : *PLDEFINED_callback)
        (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        (fill_width : PLFLT)
        (cont_color : PLINT)
        (cont_width : PLFLT)
        (fill : *PLFILL_callback)
        (rectangular : PLBOOL)
        (pltr : *PLTRANSFORM_callback)
        (pltr_data : PLPointer)
        -> _void))

(define-ffi+provide plfshades
  (_fun (zops : PLF2OPS)
        (zp : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (defined : *PLDEFINED_callback)
        (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        (fill_width : PLFLT)
        (cont_color : PLINT)
        (cont_width : PLFLT)
        (fill : *PLFILL_callback)
        (rectangular : PLINT)
        (pltr : *PLTRANSFORM_callback)
        (pltr_data : PLPointer)
        -> _void))

(define-ffi+provide plfshade
  (_fun (f2eval : *PLF2EVAL_callback)
        (f2eval_data : PLPointer)
        (c2eval : *PLF2EVAL_callback)
        (c2eval_data : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (left : PLFLT)
        (right : PLFLT)
        (bottom : PLFLT)
        (top : PLFLT)
        (shade_min : PLFLT)
        (shade_max : PLFLT)
        (sh_cmap : PLINT)
        (sh_color : PLFLT)
        (sh_width : PLFLT)
        (min_color : PLINT)
        (min_width : PLFLT)
        (max_color : PLINT)
        (max_width : PLFLT)
        (fill : *PLFILL_callback)
        (rectangular : PLBOOL)
        (pltr : *PLTRANSFORM_callback)
        (pltr_data : PLPointer)
        -> _void))

(define-ffi+provide plfshade1
  (_fun (zops : PLF2OPS)
        (zp : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (defined : *PLDEFINED_callback)
        (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (shade_min : PLFLT)
        (shade_max : PLFLT)
        (sh_cmap : PLINT)
        (sh_color : PLFLT)
        (sh_width : PLFLT)
        (min_color : PLINT)
        (min_width : PLFLT)
        (max_color : PLINT)
        (max_width : PLFLT)
        (fill : *PLFILL_callback)
        (rectangular : PLINT)
        (pltr : *PLTRANSFORM_callback)
        (pltr_data : PLPointer)
        -> _void))

;; Setup a user-provided custom labeling function
(define-ffi+provide c_plslabelfunc
  (_fun (label_func : *PLLABEL_FUNC_callback)
        (label_data : PLPointer)
        -> _void))

;; Set up lengths of major tick marks.
(define-ffi+provide c_plsmaj
  (_fun (def : PLFLT)
        (scale : PLFLT)
        -> _void))

;; Set the RGB memory area to be plotted (with the 'mem' or 'memcairo' drivers)
(define-ffi+provide c_plsmem
  (_fun (maxx : PLINT)
        (maxy : PLINT)
        (plotmem : PLPointer)
        -> _void))

;; Set the RGBA memory area to be plotted (with the 'memcairo' driver)
(define-ffi+provide c_plsmema
  (_fun (maxx : PLINT)
        (maxy : PLINT)
        (plotmem : PLPointer)
        -> _void))

;; Set up lengths of minor tick marks.
(define-ffi+provide c_plsmin
  (_fun (def : PLFLT)
        (scale : PLFLT)
        -> _void))

;; Set orientation.  Must be done before calling plinit.
(define-ffi+provide c_plsori
  (_fun (ori : PLINT)
        -> _void))

;; Set output device parameters.  Usually ignored by the driver.
(define-ffi+provide c_plspage
  (_fun (xp : PLFLT)
        (yp : PLFLT)
        (xleng : PLINT)
        (yleng : PLINT)
        (xoff : PLINT)
        (yoff : PLINT)
        -> _void))

;; Set the colors for color table 0 from a cmap0 file
(define-ffi+provide c_plspal0
  (_fun (filename : PLCHAR_VECTOR)
        -> _void))

;; Set the colors for color table 1 from a cmap1 file
(define-ffi+provide c_plspal1
  (_fun (filename : PLCHAR_VECTOR)
        (interpolate : PLBOOL)
        -> _void))

;; Set the pause (on end-of-page) status
(define-ffi+provide c_plspause
  (_fun (pause : PLBOOL)
        -> _void))

;; Set stream number.
(define-ffi+provide c_plsstrm
  (_fun (strm : PLINT)
        -> _void))

;; Set the number of subwindows in x and y
(define-ffi+provide c_plssub
  (_fun (nx : PLINT)
        (ny : PLINT)
        -> _void))

;; Set symbol height.
(define-ffi+provide c_plssym
  (_fun (def : PLFLT)
        (scale : PLFLT)
        -> _void))

;; Initialize PLplot, passing in the windows/page settings.
(define-ffi+provide c_plstar
  (_fun (nx : PLINT)
        (ny : PLINT)
        -> _void))

;; Initialize PLplot, passing the device name and windows/page settings.
(define-ffi+provide c_plstart
  (_fun (devname : PLCHAR_VECTOR)
        (nx : PLINT)
        (ny : PLINT)
        -> _void))

;; Set the coordinate transform
(define-ffi+provide c_plstransform
  (_fun (coordinate_transform : *PLTRANSFORM_callback)
        (coordinate_transform_data : PLPointer)
        -> _void))


;; Prints out the same string repeatedly at the n points in world
;; coordinates given by the x and y arrays.  Supersedes plpoin and
;; plsymbol for the case where text refers to a unicode glyph either
;; directly as UTF-8 or indirectly via the standard text escape
;; sequences allowed for PLplot input strings.
(define-ffi+provide c_plstring
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (string : PLCHAR_VECTOR)
        -> _void))

;; Prints out the same string repeatedly at the n points in world
;; coordinates given by the x, y, and z arrays.  Supersedes plpoin3
;; for the case where text refers to a unicode glyph either directly
;; as UTF-8 or indirectly via the standard text escape sequences
;; allowed for PLplot input strings.
(define-ffi+provide c_plstring3
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_VECTOR)
        (string : PLCHAR_VECTOR)
        -> _void))

;; Add a point to a stripchart.
(define-ffi+provide c_plstripa
  (_fun (id : PLINT)
        (pen : PLINT)
        (x : PLFLT)
        (y : PLFLT)
        -> _void))

;; Create 1d stripchart
(define-ffi+provide c_plstripc
  (_fun (id : (_ptr o PLINT))
        (xspec : PLCHAR_VECTOR)
        (yspec : PLCHAR_VECTOR)
        (xmin : PLFLT)
        (xmax : PLFLT)
        (xjump : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (xlpos : PLFLT)
        (ylpos : PLFLT)
        (y_ascl : PLBOOL)
        (acc : PLBOOL)
        (colbox : PLINT)
        (collab : PLINT)
        (colline : PLINT_VECTOR)
        (styline : PLINT_VECTOR)
        (legline : PLCHAR_MATRIX)
        (labx : PLCHAR_VECTOR)
        (laby : PLCHAR_VECTOR)
        (labtop : PLCHAR_VECTOR)
        -> _void
        -> id))

;; Deletes and releases memory used by a stripchart.
(define-ffi+provide c_plstripd
  (_fun (id : PLINT)
        -> _void))

;; plots a 2d image (or a matrix too large for plshade())
(define-ffi+provide c_plimagefr
  (_fun (idata : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (zmin : PLFLT)
        (zmax : PLFLT)
        (valuemin : PLFLT)
        (valuemax : PLFLT)
        (pltr : *PLTRANSFORM_callback)
        (pltr_data : PLPointer)
        -> _void))

;;
;; Like plimagefr, but uses an evaluator function to access image data from
;; idatap.  getminmax is only used if zmin == zmax.
;;
(define-ffi+provide plfimagefr
  (_fun (idataops : PLF2OPS)
        (idatap : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (zmin : PLFLT)
        (zmax : PLFLT)
        (valuemin : PLFLT)
        (valuemax : PLFLT)
        (pltr : *PLTRANSFORM_callback)
        (pltr_data : PLPointer)
        -> _void))

;; plots a 2d image (or a matrix too large for plshade()) - colors
;; automatically scaled
(define-ffi+provide c_plimage
  (_fun (idata : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (zmin : PLFLT)
        (zmax : PLFLT)
        (Dxmin : PLFLT)
        (Dxmax : PLFLT)
        (Dymin : PLFLT)
        (Dymax : PLFLT)
        -> _void))

;;
;; Like plimage, but uses an operator functions to access image data from
;; idatap.
;;
(define-ffi+provide plfimage
  (_fun (idataops : PLF2OPS)
        (idatap : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (zmin : PLFLT)
        (zmax : PLFLT)
        (Dxmin : PLFLT)
        (Dxmax : PLFLT)
        (Dymin : PLFLT)
        (Dymax : PLFLT)
        -> _void))

;; Set up a new line style
(define-ffi+provide c_plstyl
  (_fun (nms : PLINT)
        (mark : (_ptr i PLINT))
        (space : (_ptr i PLINT))
        -> _void))

;; Plots the 3d surface representation of the function z[x][y].
(define-ffi+provide c_plsurf3d
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        -> _void))

;; Like plsurf3d, but uses an evaluator function to access z data from zp
(define-ffi+provide plfsurf3d
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (zops : PLF2OPS)
        (zp : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        -> _void))

;; Plots the 3d surface representation of the function z[x][y] with y
;; index limits.
(define-ffi+provide c_plsurf3dl
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (z : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        (indexxmin : PLINT)
        (indexxmax : PLINT)
        (indexymin : PLINT_VECTOR)
        (indexymax : PLINT_VECTOR)
        -> _void))

;; Like plsurf3dl, but uses an evaluator function to access z data from zp
(define-ffi+provide plfsurf3dl
  (_fun (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (zops : PLF2OPS)
        (zp : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (opt : PLINT)
        (clevel : PLFLT_VECTOR)
        (nlevel : PLINT)
        (indexxmin : PLINT)
        (indexxmax : PLINT)
        (indexymin : PLINT_VECTOR)
        (indexymax : PLINT_VECTOR)
        -> _void))

;; Set arrow style for vector plots.
(define-ffi+provide c_plsvect
  (_fun (arrowx : PLFLT_VECTOR)
        (arrowy : PLFLT_VECTOR)
        (npts : PLINT)
        (fill : PLBOOL)
        -> _void))

;; Sets the edges of the viewport to the specified absolute coordinates
(define-ffi+provide c_plsvpa
  (_fun (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        -> _void))

;; Set x axis labeling parameters
(define-ffi+provide c_plsxax
  (_fun (digmax : PLINT)
        (digits : PLINT)
        -> _void))

;; Set inferior X window
(define-ffi+provide plsxwin
  (_fun (window_id : PLINT)
        -> _void))

;; Set y axis labeling parameters
(define-ffi+provide c_plsyax
  (_fun (digmax : PLINT)
        (digits : PLINT)
        -> _void))

;; Plots array y against x for n points using Hershey symbol "code"
(define-ffi+provide c_plsym
  (_fun (n : PLINT)
        (x : PLFLT_VECTOR)
        (y : PLFLT_VECTOR)
        (code : PLINT)
        -> _void))

;; Set z axis labeling parameters
(define-ffi+provide c_plszax
  (_fun (digmax : PLINT)
        (digits : PLINT)
        -> _void))

;; Switches to text screen.
(define-ffi+provide c_pltext
  (_fun -> _void))

;; Set the format for date / time labels for current stream.
(define-ffi+provide c_pltimefmt
  (_fun (fmt : PLCHAR_VECTOR)
        -> _void))

;; Sets the edges of the viewport with the given aspect ratio, leaving
;; room for labels.
(define-ffi+provide c_plvasp
  (_fun (aspect : PLFLT)
        -> _void))

;; Creates the largest viewport of the specified aspect ratio that fits
;; within the specified normalized subpage coordinates.

;; simple arrow plotter.
(define-ffi+provide c_plvect
  (_fun (u : PLFLT_MATRIX)
        (v : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (scale : PLFLT)
        (pltr : *PLTRANSFORM_callback)
        (pltr_data : PLPointer)
        -> _void))

;;
;; Routine to plot a vector array with arbitrary coordinate
;; and vector transformations
;;
(define-ffi+provide plfvect
  (_fun (getuv : *PLF2EVAL_callback)
        (up : PLPointer)
        (vp : PLPointer)
        (nx : PLINT)
        (ny : PLINT)
        (scale : PLFLT)
        (pltr : *PLTRANSFORM_callback)
        (pltr_data : PLPointer)
        -> _void))

(define-ffi+provide c_plvpas
  (_fun (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (aspect : PLFLT)
        -> _void))

;; Creates a viewport with the specified normalized subpage coordinates.
(define-ffi+provide c_plvpor
  (_fun (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        -> _void))

;; Defines a "standard" viewport with seven character heights for
;; the left margin and four character heights everywhere else.
(define-ffi+provide c_plvsta
  (_fun -> _void))

;; Set up a window for three-dimensional plotting.
(define-ffi+provide c_plw3d
  (_fun (basex : PLFLT)
        (basey : PLFLT)
        (height : PLFLT)
        (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        (zmin : PLFLT)
        (zmax : PLFLT)
        (alt : PLFLT)
        (az : PLFLT)
        -> _void))

;; Set pen width.
(define-ffi+provide c_plwidth
  (_fun (width) ::
        (width : PLFLT = (+ width 0.0))
        -> _void))

;; Set up world coordinates of the viewport boundaries (2d plots).
(define-ffi+provide c_plwind
  (_fun (xmin : PLFLT)
        (xmax : PLFLT)
        (ymin : PLFLT)
        (ymax : PLFLT)
        -> _void))

;; Set xor mode; mode = 1-enter, 0-leave, status = 0 if not interactive device
(define-ffi+provide c_plxormod
  (_fun (mode : PLBOOL)
        (status : (_ptr o PLBOOL))
        -> _void
        -> status))


;;--------------------------------------------------------------------------
;;		Functions for use from C or C++ only
;;--------------------------------------------------------------------------

;; Returns a list of file-oriented device names and their menu strings
(define-ffi+provide plgFileDevs
  (_fun (**p_menustr : PLCHAR_VECTOR)
        (**p_devname : PLCHAR_VECTOR)
        (*p_ndev : _int)
        -> _void))

;; Returns a list of all device names and their menu strings
(define-ffi+provide plgDevs
  (_fun (**p_menustr : PLCHAR_VECTOR)
        (**p_devname : PLCHAR_VECTOR)
        (*p_ndev : _int)
        -> _void))

;; Set the function pointer for the keyboard event handler
(define-ffi+provide plsKeyEH
  (_fun (KeyEH : (_fun _PLGraphicsIn-pointer/null ;; graphics_in
                       ;;user_data, p_exit_eventLoop
                       PLPointer _pointer -> _void)) 
        (KeyEH_data : _pointer)
        -> _void))

;; Set the function pointer for the (mouse) button event handler
(define-ffi+provide plsButtonEH
  (_fun (KeyEH : (_fun _PLGraphicsIn-pointer/null ;; graphics_in
                       ;;user_data, p_exit_eventLoop
                       PLPointer _pointer -> _void))
        (ButtonEH_data : PLPointer)
        -> _void))

;; Sets an optional user bop handler
(define-ffi+provide plsbopH
  (_fun (*handler : (_fun PLPointer _pointer -> _void))
        (handler_data : PLPointer)
        -> _void))

;; Sets an optional user eop handler
(define-ffi+provide plseopH
  (_fun (*handler : (_fun PLPointer _pointer -> _void))
        (handler_data : PLPointer)
        -> _void))

;; Set the variables to be used for storing error info
(define-ffi+provide plsError
  (_fun (errcode : PLINT_NC_SCALAR)
        (errmsg : PLCHAR_NC_VECTOR)
        -> _void))

;; Sets an optional user exit handler.
(define-ffi+provide plsexit
  (_fun (*handler : (_fun PLCHAR_VECTOR -> _int))
        -> _void))

;; Sets an optional user abort handler.
(define-ffi+provide plsabort
  (_fun (*handler : (_fun PLCHAR_VECTOR -> _void))
        -> _void))

;; Transformation routines

;; Identity transformation.
(define-ffi+provide pltr0
  (_fun (x : PLFLT)
        (y : PLFLT)
        (tx : PLFLT_NC_SCALAR)
        (ty : PLFLT_NC_SCALAR)
        (pltr_data : PLPointer)
        -> _void))

;; Does linear interpolation from singly dimensioned coord arrays.
(define-ffi+provide pltr1
  (_fun (x : PLFLT)
        (y : PLFLT)
        (tx : PLFLT_NC_SCALAR)
        (ty : PLFLT_NC_SCALAR)
        (pltr_data : PLPointer)
        -> _void))

;; Does linear interpolation from doubly dimensioned coord arrays
;; (column dominant, as per normal C 2d arrays).
(define-ffi+provide pltr2
  (_fun (x : PLFLT)
        (y : PLFLT)
        (tx : PLFLT_NC_SCALAR)
        (ty : PLFLT_NC_SCALAR)
        (pltr_data : PLPointer)
        -> _void))

;; Just like pltr2() but uses pointer arithmetic to get coordinates from
;; 2d grid tables.
(define-ffi+provide pltr2p
  (_fun (x : PLFLT)
        (y : PLFLT)
        (tx : PLFLT_NC_SCALAR)
        (ty : PLFLT_NC_SCALAR)
        (pltr_data : PLPointer)
        -> _void))

;; Does linear interpolation from doubly dimensioned coord arrays
;; (row dominant, i.e. Fortran ordering).
(define-ffi+provide pltr2f
  (_fun (x : PLFLT)
        (y : PLFLT)
        (tx : PLFLT_NC_SCALAR)
        (ty : PLFLT_NC_SCALAR)
        (pltr_data : PLPointer)
        -> _void))

;;
;; Returns a pointer to a plf2ops_t stucture with pointers to functions for
;; accessing 2-D data referenced as (PLFLT **), such as the C variable z
;; declared as...
;;
;;   PLFLT z[nx][ny];
;;
(define-ffi+provide plf2ops_c
  (_fun -> PLF2OPS))

;;
;; Returns a pointer to a plf2ops_t stucture with pointers to functions for accessing 2-D data
;; referenced as (PLfGrid2 *), where the PLfGrid2's "f" is treated as type
;; (PLFLT **).
;;
(define-ffi+provide plf2ops_grid_c
  (_fun -> PLF2OPS))

;;
;; Returns a pointer to a plf2ops_t stucture with pointers to functions for
;; accessing 2-D data stored in (PLfGrid2 *), with the PLfGrid2's "f" field
;; treated as type (PLFLT *) pointing to 2-D data stored in row-major order.
;; In the context of plotting, it might be easier to think of it as "X-major"
;; order.  In this ordering, values for a single X index are stored in
;; consecutive memory locations.
;;
(define-ffi+provide plf2ops_grid_row_major
  (_fun -> PLF2OPS))

;;
;; Returns a pointer to a plf2ops_t stucture with pointers to functions for
;; accessing 2-D data stored in (PLfGrid2 *), with the PLfGrid2's "f" field
;; treated as type (PLFLT *) pointing to 2-D data stored in column-major order.
;; In the context of plotting, it might be easier to think of it as "Y-major"
;; order.  In this ordering, values for a single Y index are stored in
;; consecutive memory locations.
;;
(define-ffi+provide plf2ops_grid_col_major
  (_fun -> PLF2OPS))


;; Function evaluators (Should these be deprecated in favor of plf2ops?)

;;
;; Does a lookup from a 2d function array.  plf2eval_data is treated as type
;; (PLFLT **) and data for (ix,iy) is returned from...
;;
;; plf2eval_data[ix][iy];
;;
(define-ffi+provide plf2eval1
  (_fun (ix : PLINT)
        (iy : PLINT)
        (plf2eval_data : PLPointer)
        -> PLFLT))

;;
;; Does a lookup from a 2d function array.  plf2eval_data is treated as type
;; (PLfGrid2 *) and data for (ix,iy) is returned from...
;;
;; plf2eval_data->f[ix][iy];
;;
(define-ffi+provide plf2eval2
  (_fun (ix : PLINT)
        (iy : PLINT)
        (plf2eval_data : PLPointer)
        -> PLFLT))

;;
;; Does a lookup from a 2d function array.  plf2eval_data is treated as type
;; (PLfGrid *) and data for (ix,iy) is returned from...
;;
;; plf2eval_data->f[ix * plf2eval_data->ny + iy];
;;
;; This is commonly called "row-major order", but in the context of plotting,
;; it might be easier to think of it as "X-major order".  In this ordering,
;; values for a single X index are stored in consecutive memory locations.
;; This is also known as C ordering.
;;
(define-ffi+provide plf2eval
  (_fun (ix : PLINT)
        (iy : PLINT)
        (plf2eval_data : PLPointer)
        -> PLFLT))

;;
;; Does a lookup from a 2d function array.  plf2eval_data is treated as type
;; (PLfGrid *) and data for (ix,iy) is returned from...
;;
;; plf2eval_data->f[ix + iy * plf2eval_data->nx];
;;
;; This is commonly called "column-major order", but in the context of
;; plotting, it might be easier to think of it as "Y-major order".  In this
;; ordering, values for a single Y index are stored in consecutive memory
;; locations.  This is also known as FORTRAN ordering.
;;
(define-ffi+provide plf2evalr
  (_fun (ix : PLINT)
        (iy : PLINT)
        (plf2eval_data : PLPointer)
        -> PLFLT))

;; Command line parsing utilities

;; Clear internal option table info structure.
(define-ffi+provide plClearOpts
  (_fun -> _void))

;; Reset internal option table info structure.
(define-ffi+provide plResetOpts
  (_fun -> _void))

;; Merge user option table into internal info structure.
(define-ffi+provide plMergeOpts
  (_fun (*options : _PLOptionTable-pointer/null)
        (name : PLCHAR_VECTOR)
        (*notes : PLCHAR_VECTOR)
        -> PLINT))

;; Set the strings used in usage and syntax messages.
(define-ffi+provide plSetUsage
  (_fun (program_string : PLCHAR_VECTOR)
        (usage_string : PLCHAR_VECTOR)
        -> _void))

;; Process input strings, treating them as an option and argument pair.
;; The first is for the external API, the second the work routine declared
;; here for backward compatibilty.
(define-ffi+provide c_plsetopt
  (_fun (opt : PLCHAR_VECTOR)
        (optarg : PLCHAR_VECTOR)
        -> PLINT))

;; Process options list using current options info.
(define-ffi+provide c_plparseopts
  (_fun (*p_argc : _pointer)
        (argv : PLCHAR_NC_MATRIX)
        (mode : PLINT)
        -> PLINT))

;; Print usage & syntax message.
(define-ffi+provide plOptUsage
  (_fun -> _void))

;; Miscellaneous

;; Set the output file pointer
(define-ffi+provide plgfile
  (_fun (**p_file : _pointer)
        -> _void))

;; Get the output file pointer
(define-ffi+provide plsfile
  (_fun (*file : _pointer)
        -> _void))

;; Get the escape character for text strings.
(define-ffi+provide plgesc
  (_fun (p_esc : PLCHAR_NC_SCALAR)
        -> _void))

;; Front-end to driver escape function.
(define-ffi+provide pl_cmd
  (_fun (op : PLINT)
        (ptr : PLPointer)
        -> _void))

;; Return full pathname for given file if executable
(define-ffi+provide plFindName
  (_fun (p : PLCHAR_NC_VECTOR)
        -> PLINT))

;; Looks for the specified executable file according to usual search path.
(define-ffi+provide plFindCommand
  (_fun (fn : PLCHAR_VECTOR)
        -> PLCHAR_NC_VECTOR))

;; Gets search name for file by concatenating the dir, subdir, and file
;; name, allocating memory as needed.
(define-ffi+provide plGetName
  (_fun (dir : PLCHAR_VECTOR)
        (subdir : PLCHAR_VECTOR)
        (filename : PLCHAR_VECTOR)
        (*filespec : PLCHAR_NC_VECTOR)
        -> _void))

;; Prompts human to input an integer in response to given message.
(define-ffi+provide plGetInt
  (_fun (s : PLCHAR_VECTOR)
        -> PLINT))

;; Prompts human to input a float in response to given message.
(define-ffi+provide plGetFlt
  (_fun (s : PLCHAR_VECTOR)
        -> PLFLT))

;; C, C++ only.  Determine the Iliffe column vector of pointers to PLFLT row
;; vectors corresponding to a 2D matrix of PLFLT's that is statically
;; allocated.
;; (define-ffi+provide plStatic2dGrid
;;   (_fun (zIliffe : PLFLT_NC_MATRIX)
;;         (zStatic : PLFLT_VECTOR)
;;         (nx : PLINT)
;;         (ny : PLINT)
;;         -> _void))

;; C, C++ only.  Allocate a block of memory for use as a 2-d grid of PLFLT's organized
;; as an Iliffe column vector of pointers to PLFLT row vectors.
(define-ffi+provide plAlloc2dGrid
  (_fun (*f : PLFLT_NC_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        -> _void))

;; Frees a block of memory allocated with plAlloc2dGrid().
(define-ffi+provide plFree2dGrid
  (_fun (f : PLFLT_NC_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        -> _void))

;; Find the maximum and minimum of a 2d matrix allocated with plAllc2dGrid().
(define-ffi+provide plMinMax2dGrid
  (_fun (f : PLFLT_MATRIX)
        (nx : PLINT)
        (ny : PLINT)
        (fmax : PLFLT_NC_SCALAR)
        (fmin : PLFLT_NC_SCALAR)
        -> _void))

;; Wait for graphics input event and translate to world coordinates
(define-ffi+provide plGetCursor
  (_fun ((*gin #f)) ::
        (gin : _PLGraphicsIn-pointer/null =
             (if *gin
                 *gin
                 (ptr-ref (malloc _PLGraphicsIn)
                          _PLGraphicsIn)))
        -> (status : PLINT)
        -> (if *gin
               status
               (values status gin))))

;; Translates relative device coordinates to world coordinates.
(define-ffi+provide plTranslateCursor
  (_fun (*gin : _PLGraphicsIn-pointer/null)
        -> PLINT))

;; Set the pointer to the data used in driver initialisation

;; N.B. Currently used only by the wxwidgets device driver and
;; associated binding.  This function might be used for other device drivers
;; later on whether written in c++ or c.  But this function is not part of the
;; common API and should not be propagated to any binding other than
;; c++.
;;(define-ffi+provide plsdevdata
;;  (_fun (data : PLPointer) -> _void))


