type
  TNotifyEvent* = proc(sender: pointer) {.nimcall.}
  
  TDropFilesEvent* = proc(sender: pointer, aFileNames: pointer, len: int) {.nimcall.}

  TPosition* = enum
    poDesigned,
    poDefault,                    # LCL decision (normally window manager decides)
    poDefaultPosOnly,             # designed size and LCL position
    poDefaultSizeOnly,            # designed position and LCL size
    poScreenCenter,               # center form on screen (depends on DefaultMonitor)
    poDesktopCenter,              # center form on desktop (total of all screens)
    poMainFormCenter,             # center form on main form (depends on DefaultMonitor)
    poOwnerFormCenter,            # center form on owner form (depends on DefaultMonitor)
    poWorkAreaCenter,             # center form on working area (depends on DefaultMonitor)


  TOpenOption* = enum
    ofReadOnly,
    ofOverwritePrompt, # if selected file exists shows a message, that file
    ofHideReadOnly, # hide read only file
    ofNoChangeDir,  # do not change current directory
    ofShowHelp,     # show a help button
    ofNoValidate,
    ofAllowMultiSelect, # allow multiselection
    ofExtensionDifferent,
    ofPathMustExist, # shows an error message if selected path does not exist
    ofFileMustExist, # shows an error message if selected file does not exist
    ofCreatePrompt,
    ofShareAware,
    ofNoReadOnlyReturn, # do not return filenames that are readonly
    ofNoTestFileCreate,
    ofNoNetworkButton,
    ofNoLongNames,
    ofOldStyleDialog,
    ofNoDereferenceLinks, # do not resolve links while dialog is shown (only on Windows, see OFN_NODEREFERENCELINKS)
    ofNoResolveLinks,     # do not resolve links after Execute
    ofEnableIncludeNotify,
    ofEnableSizing,    # dialog can be resized, e.g. via the mouse
    ofDontAddToRecent, # do not add the path to the history list
    ofForceShowHidden, # show hidden files
    ofViewDetail,      # details are OS and interface dependent
    ofAutoPreview,     # details are OS and interface dependent

  TOpenOptions* = set[TOpenOption]
 